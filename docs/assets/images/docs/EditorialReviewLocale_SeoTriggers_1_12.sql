﻿CREATE UNIQUE INDEX [IX_Name_CatalogId] ON [dbo].[Property]([Name], [CatalogId])
ALTER TABLE [dbo].[Property] ADD [TargetType] [nvarchar](128)
ALTER TABLE [dbo].[EditorialReview] ADD [Locale] [nvarchar](64)
GO
                ALTER TRIGGER [TR_CategoryDeleteTrigger] ON [dbo].[Category]
                FOR DELETE
                AS
                BEGIN

                IF(EXISTS((SELECT CategoryId FROM [deleted])))
	                BEGIN

		                DECLARE @TempParentCategoryId TABLE
		                (
		                   CategoryId nvarchar(128)
		                );

		                INSERT INTO @TempParentCategoryId 
		                SELECT CategoryId FROM [dbo].[CategoryBase] 
		                WHERE ParentCategoryId IN (SELECT CategoryId FROM [deleted])

		                DELETE FROM [dbo].[Category] WHERE CategoryId IN (SELECT CategoryId FROM @TempParentCategoryId)
		                DELETE FROM [dbo].[LinkedCategory] WHERE LinkedCategoryId IN (SELECT CategoryId FROM [deleted])
		                DELETE FROM [dbo].[LinkedCategory] WHERE CategoryId IN (SELECT CategoryId FROM @TempParentCategoryId)
		                DELETE FROM [dbo].[CategoryItemRelation] WHERE CategoryId IN (SELECT CategoryId FROM [deleted])
		                DELETE FROM [dbo].[CategoryItemRelation] WHERE CategoryId IN (SELECT CategoryId FROM @TempParentCategoryId)
		                DELETE FROM [dbo].[CategoryBase] WHERE ParentCategoryId IN (SELECT CategoryId FROM [deleted])
                        IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'SeoUrlKeyword'))
	                    BEGIN
		                    DELETE FROM [dbo].[SeoUrlKeyword] WHERE KeywordType = 0 AND KeywordValue IN (SELECT CategoryId FROM [deleted])
	                    END
	                END
                END
GO
                CREATE TRIGGER [dbo].[TR_ItemDeleteTrigger] ON [dbo].[Item] 
                FOR DELETE AS
                BEGIN
	                IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'SeoUrlKeyword'))
	                BEGIN
		                DELETE FROM [dbo].[SeoUrlKeyword] WHERE KeywordType = 1 AND KeywordValue IN (SELECT ItemId FROM [deleted])
	                END
                END
GO

INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
VALUES (N'201409031214424_EditorialReviewLocale_SeoTriggers', N'VCF.Catalogs',  0x1F8B0800000000000400ED5D5B73DCB8B17E3F55E73FA8E629495534B673A9242527654B7656B5F67A63399B47153D0349AC9DE14C488E57CE5F3B0FE7279DBF70407248E2D268DC7991E74535228006D0F8BAD168008DFFFB9FFFBDF8DBE37673F685E445BACB5E2E9E9F3F5B9C916CB55BA7D9FDCBC5A1BCFBED9F167FFBEB7FFFD7C59BF5F6F1ECA736DFEFAA7CB46456BC5C3C94E5FE2FCB65B17A20DBA438DFA6AB7C57ECEECAF3D56EBB4CD6BBE58B67CFFEBC7CFE7C49288905A5757676F1F19095E996D4FFD07F2F77D98AECCB43B279BF5B934D71FC4E536E6AAA673F245B52EC931579B9F829CDCBDDE56EBB25F98A9CBFDD1DB27552D2469D5F2565727E49FF6C76F7C5E2ECD5264D68EB6EC8E66E719664D9AEACB3FDE59F05B929F35D767FB3A71F92CDA7AF7B42F3DD259B821CFBF4973EBB69F79EBDA8BAB7EC0B3AB167D1759C76FD0D6551F9B56A5EDDFD978B63DF5E2755435F7D2ECA3C59952F17657E206C415AF47BF295FB403FFD98EFF6242FBF7E24773CB9EBF5E26CC9175F8AE5BBD272D1AA7D94CB654E01B3387B9F3CBE23D97DF940A1F4E24F8BB3B7E92359B75F8E2CFE6796527C9163C3CF7E386C36C9E70DE9D29768D5D5DFE16BBD2277C96153BE4BB2FB43728F35E08FBF8F51FF875F32920761375ECFBBA428A908A67729E92AA372453EA55B6DD9CB9CD09CFA623F245FD2FB5A46645491FB5DFEB5023815E08F6453E72A1ED27D23C7E76C8EDB230869AFF3DDF6E36E235068D36F3F25F93D2969B37648A69BDD81AA13BEAD17CB5E047582D9510C2499353D47D1ECCA0E2D2597B4E8E0A2715DBC5A95E997AEE2D73B3ACA49664DE7C73CDDE5745C5B3AD759F9BB17F62C184F33FE98E4242B838EFFB4954523FDA1D444AB015035D1EA12D356BE4BB39FC9FA482A5568352ED3D7DBF647F5996D35924DD271585E48D5617DE071A567B8985FC1773E1BCE7E212F340AC6CA9A67CDE2ACAAE0282862571638FC5B4263093CDF931802AF93BE06A24690EEB363886E73497040B2DACA242F5F71E451DF7C5976BD4C0F0F1C8F6351DF94495E566A5F9E022C29BDC9D6301DDD7CDFFC7B43CAA145A71E98F6F34FC9E6A03177B9ACB7986685732A4D604576EB19A26725DA8F5B2EA3DC7A365D3921709982C80EC705177B9D23E062B44B0406B7DC475C35D48E1AFF658397DB20481D74941B08C536BCEB5AAA3AFCD62A370FBBBCFC441E4B5DABFFF0FC4588E5C22EBB37A98DFE0C50DB1559A5DB64C35576FCB638FB31A7BF8E1E4F3A2037ABA4629A3D0729DFC93DC9B94ADCC6E2B86AE528B9AE64DB1990EFBBE1B4F86E573123B6A88CBD74D42F65BCE75CD5FCA599A29D6632765EF598BF8EA690EBEC15CA929A8547B8192F56090FE6F10AB9E49CB698621E9EDA1FC340AF1064534A87AC60399387ED7BFCA972F3C8399506B126ABD4135D7E5FEF76330EF20AB3DB8E4291F02F92DE3F94EF49521C72DB6952EB8138EEC82817506C26852F10CAA2028B94CF032F689BEDA00D4C366AFCFBA0A0DB0173DF706C49786C3CB22406F7BA05DB039CEC4EC2D4D5BE8B3C2B244429F7BE7658FBD3D31E6B7F7ADA652C99C1F7A5826CAC8DDB83510DDC51C5B1C3B1AD49636ACF48928966B675F6EB5C93018D329B7E78FB2E43A8171F9D725AE845586E5D1794FDBEDE9FEBE28671E0B85379931DB6FE54AEB3FDA1F427F391FCFB90E6BD1E73A7F4FEB029D3206EB6EBA2F1955D913DC9D649E6DDCD579BCDEE17CE1BEE7E9685F131F93B8A9BEDF7A0A27FF270684CDD6ECA006C5C314D39F5389F5BE1471C6FA0981768279F45DD5C219FEB64FFAAA470F97C28358E982E1B6AB3C8B994EE1720ABAB7B00D915968C89362FC4782E0BC2783E5F10D3A4E3868F8DD211F131563822632D1EBA468C63C648CD08B555F9CDAD06A7BF1C73566C2AFD80E8402F15F10D9FB818D59FC14DB3E158703AE7713AE7713AE7713AE73195B9525673E8B4D99CC8004BC9B3A732B372125597705DE7845E1EA8D635AA6584D3DC5FDDDF3C241B935D65BE0289D27549B621AE5B55745C6C88B6DCD4FCA0CF5E44397632FA89ED5037BDAE8BD787AF557E6F87DD9724A5F9D30DC5E5C7C3C6736A789F66FF382435C8A34D641426D1EBF844A5F1E7EBEC0B5573F589393F1E378747A235F647DAD6E49E33B2A299739F92C7FE1C616C0FEA18573199DDAD910EB17F0B5EE35745B15BA575CADFF3DD610F7B09ABC9E916C8DA5B01700EC97C516473B875A5F475D755007E6EF63BDC2E57FF7677DF8112E91A84B60DCA2EB754CEA56C3790D5B6176FD62955B169B2F948BEA4E417B80342A696658DF1D4F700C926D985585E5B87775588A24B751AAEA6C9E61178DE27C18C66D26DB95B153570C74BD9541C46334A3CC67387BEA15513E532097C66D26046B319BC7C83A2AA71B1E8451A2ED63D44636A967EAC6027C52A4FF74D149BC8CEA230DB0163ADC4A66207C09A4944F02D5FA2977034A324EE786E47BBA0519621ED1848A122E68EAFAEF254539E1A6A947B9B7DF581964FA36C254E41CF7FEBFAAB99E823EA3051199869BC503A8C21AE320E155930E50B9A8FAE773BA4D58857DC2A868E570C2B81CE3C15CC58C23D6A24B0D3E515E5CD6216D558742A289FF2563198398A2DE6E30B016D32DC6D62EBD1B162BDF24E3798D198F9016E740B2E16176D2C907051C4008979EAE06EE4627BDDB392F407C1A31D7A6886E3A66436D11CC315567174B3123B9613A6C5C31C37F826ED689DD60EE00016159F89B3D849ED75EE5AD77DFCBAB0EB667E577884A5F488156B56EF71F60AEB655798D37AD673415E7EC8D7249FA7593F695D63B15D03DA82C0768EB31E391D321E0DA3A7A3BEB6159D8EFA9E8EFA9E8EFA469D97026CD2433BDFFA2D7DA719ECF5215B5783261C8F6DDA8B9F8BBDFA9A25DB74F57D5A3A153F1E89732B9BEFD687955BBD373F1F9CCAF97AAD7DBDD5637BA9DBBAAB7AD1FA838879F4E3A3E32D0C02BD00F1906ED663195ECDED826F7369D2F25D3901F42EDA3E2BAFF9E51CA0CA07B2B95DB0376B2E9B57D1DE3E0BDE60269FE705CE74E5B8A6A205DDD652C78243839A8DA6A257761A01498B7847D987B83F508FC286F6E25B5ACD4EDAB2AD474465CD4A89C0E5343187FD65B42324D4CDAB526FEB5F85D43A260DB87F2664F0F209F50D75D55B2DF09D74D75852F3F4CF905E1E723AABADB04B35710CC691234134F2E42B74A04680A4D24FE85E15457A9F559B8D5EE2D793F112449ECC4924A779AC1BB9718A1774BC607AB9CBD669C59F378FFB9C1405CEA9304E4D6A99ADD3156DE04F697148369F72426E48B5B59AFE8760D00C55FB8833D3E99018A2BA7B0D0547805366532B74206F24638FA989298137BF9F774C3AD0E7F69B9E6A5F67053A9749A971943A4D447DD1994E3E43CE35B657C6D375F9106D09FC5DDC0BE957641FB1F10D9FDD9E62185A851A0B317BAFDE418C99E22EA22C141F78093288348F36D4CC6D07E1982FF7B42FDF006AFC9D99BCF3DBEF32716F659ED51182F79B74451BF472F11BA9831AFA9D1383A3DFC7B4E1C93F5F8800FD905D910D29C95915ECA412F8CBA458256B99D194676BFE0BC534A9FCBBD47AA4A66C151627CD4A5900D26C95EE938D412784B2A0F83056DC52AC6BD95526A6344193695B0D86CABB155D65020375FCBA583200C471893C78AB428FC9EBB73D86C4678BCD516AF074EE5CB0AAEFCA7088D50F9F495BA447A42782DEFEC563735801CF1FC7C12FF0EEB999327F767EFE5CAA291012A54619425161787862511A0B2B30226D1A008DDC5C20BC266F3415AB9E960F3CE32B5EA51F1C8B068D1A108B062361D21ABEE4E858944E7999C1112E8621923FB5EC004D4595083AA737CF9BF5650450E3E3E9DFA061100DBEA186E00A7F504DB21DFB17F2ACD08B3FC328D53249D4627D187431850DD91CD6536D93DB96D5AF606AC0A37812538B1C7026D6500770C9A4EB91EF0330B09F83A30BE4C71CA0D5B648ABF9C48C10A4DA3C36BA4EA26BAEE4C2198DAA460C8723157B678521E1F123ED90AB5E420A8428C5034A06E423200B6E8C91F17FFC120A6130D7CD9721787B06C41BF0B28B0E13D8332F322CFA479B1CE0873D95A547E0F8069CBE1F2380573D7EFE8D1910B9EAC71574A8327869410697F5F2595F1B0265B0B6F01A55DB361B44286E353B61543B44F6AA1669DEA0F33BDB1CF50A4491DF667E0FAAFEF42DB34573A0258C8651A31807206366A55CC1F7B77588C01FE306D7B53EB629FA9CF7ACCC03AC272300181BC7D9A3F8460A0564862C2E4EF9205866039F9B7985A68D68A63F3628BA81C22F05C33533AC411A35E00E9211A4A1CCD86E91CB069107626B93766CD062FD1816A9D868CD059EAAD8C42A14690315F74062A3A35BE05417E2580A0F216AD52086AAA61526C30BBF2B6785300DB7FD5A312CBA80F0DD0608C0DE230091760C253EC8DACA30E6B8A344F8C256CD3A13D8E89F507105B29A55E1DA3500B4150F53A8B0A27B6D4BA7D4A20058F77486B98405822FCEA581942ECE95C9EB5CEE353574E4917D4D0884D8A40DBEC66676AC389C9F146A84C97085D9CF8458EA5DFB800B14302EBD6E318107A997172C5CB02E87C50B1AE77E2EC7D84D3A331C6E4D8672CE38363BA9A989F81F1FC94E8788039F2046DB64888190C72DD141F16FCF809331F064866E2AC5DE121DCF5A841B86C0D64E4EBCE67D35C786B41C510E4DDE7AC45E0B5001C3E8E9801E19E2DB2616CAD3E895DA0185C309AE069D1808AF06033779C08A21E751ED05C4971F519742D1F0F9D6346F6144D49A32438654953203660137FE888B8986340C2BCD0FBEF35926B3B0D493D79346DD1810AEDA019C05788DF621C58CC15C4473DE2D5775C064D8C36D3AAA8626482B06C220108919430D169699C7A3CB825C13D17998ED46BC11032A3935AF8DD6DB6CF0F3F1E1C544CE361A7D288C7660800111B8673111231D18039DF24819E93F2E3CFE4887DDC478CD2AD820C19BD909B30AC46E75844D15F079F23054367D20002A0764F2769F1410184507181D58805C13D171A013ECAA30E1D662E00E3B8027660697326CB83DF4001E0468C390F003829A6A471D8B700A809289336DAB15353152E7B2BB68D01723532ED0255FED307A37662404ABDE13C0510584B98D8A623950EEE0AA3C188AA5BE8CA282B1C19CA23E7E5387D6AC9E26A72548DEEEF3BC3DCAD447B2DF15D53680BC475E95BB21252F8395D22B16676FBA809D904E94202A91EAB6B415B4982D6F4362C2553D3555C1AFAA21CFF84C20A29CC74ADF52362E0BC2C53E848E79EB8E3F53902E78F1C58C364ED0B885DD3D668C1A73FDDC90AC72B4ED46B932CF212ACD4A4853583E052A13920F509A13D5D0339610FEFC815A4078478786B8B08708D195367C0D06A37D401A1C91E3B69801192D4C808D1603B21817ADB8D73ED002C037155F3A5215AFE612258966763725D3CF6D2841D63CD1916E23EC8304BBF0FB3A327D946D581DB131C0455A8CA8C05350FFC2029315988AE0450B678241D93B4BAFEB9434034A668086626BCBF11499E95934CA781E18F00709680C70C934FC31D7338300C84E1C3308783C24DFFA50BA468C5344DED5F4508EBD1B887572AC5D53C20ECCE3B02E447ED5C9261628562D508A50B1FE92AA080E3B00F3A46D6A2DFF1425F43D850B625C14E76303762A2A1986A360A84C9895FAA89A62F7D0B89AB28A62D60D38DBD0489AF1545F5B13BF6252F20A89ED0875088EEE68D81B3D41803D7C3FBCD9D35D66476024E551F742CC0AB1845DC1210C9148C5C74A7FB39F0FA087F1048BB507F747116DCF83438A007B46143DD804C47D4338A58B1207760D891307C804BB9A37E01B12192E36EBD481C7100E1A462B03FBAA8F5706F0D3603ED4D34774184CDF4B7005CA98E0F2594DC48C2B114470798A43B20A8CCE84F04B1FCD09EC221ACF099ED62C998886708A2DC7AAE840968C944E3D1AF7943D06198D9DECB9C878A64867446B1809E6D35BEC3A96D92FA906E68F22EC06C4225556759F14252046F13E60844F2A9A00AB8E9EEE903C02427BE09CD2C50251F50D89060273AD75C79BB10E09E26138280E7C84A30D400C54E454770D2E00B10C0485092D9C3F30FB5D9984AC9BB8744D2790F592211B065D52ABEFE6230A1BCCAF57B3D8157048810B5B21068A1CAC613C3E6A5D637001FB7E6A1D63FEAC1CCC2D86DC6946445377031A1433E40EB493D82257976DC7C48171D8DD5A8073C65771B9AE9A5CC665FA2A6FDF226C34B97E1BC1D410AF78AA50A6BA052A4301B8076A8F27E0FAA640A46D6F100E487E700C3B16D714A58E29CBA97865E1C430BB9A180B439AE50E7E3D4E068066996308A36197368AEB570A6EE82E6A49BD41AE6A099C319BEC3497B3220105BA40A4E390EAAE91BA3BC06D237F1E01F78B223049BEC502BA61D0AB2E824F4475D9851385E6B00CEA5B515D6F89C505F65A858A09CAAB1772DBA1CB17220B8E077E746C80EE4C68B9E9C38657F2F17E8C234076831EC9A5503E71279A4C3806D01F623B0C3B5F6EC844C581746D37E523E9A119291F42378234C2C8EA983977ACB94BBB58DEAC1EC836397EB858D22C2BB22F0FC9E6FD6E4D36459BF03ED9EFAB73697DC9E397B39B7DB2AA165ABFBD599C3D6E3759F172F15096FBBF2C97454DBA38DFA6AB7C57ECEECAF3D56EBB4CD6BBE58B67CFFEBC7CFE7CB96D682C579CA48B87B0BB9AA8399DDC132195564D5BFA36CD8BF28AE2EC737D0AFA72BD95B2591CE26E6B840E60CB83D99EAE6B4B55BF9B923FA579B9BBDC6DB78422E5FCEDEE90ADEBE139AF5ADA6EED17E273DF420D3DAFDFD2EE5710A939411854E808501237AB6493E4AD7D0444FCBADC6D0EDB4C1F094C4D4D7A9E9D25A97DBBDD802ED856FD3BDC15AE050E8A83B8944631C2307B0CF0D8435BFDE5E9345FCC29DC94495E09A84086F96C4E8BEA4F9952F7D19C0EB35A10D924240D0EA9EBA2FAFDE1EE5796D8AA74D4AF3D00565F22190964951E17E8ECE43B531885EBA2BA70F545A0D27FB58146BACBD36AEB994745FBD5A257B03E74D284F23BEF5CEBB4AFC0AB29BF4B8A92CEF8E95D4A44FDCAA558F43B27B42562AFDB8FE105AA4DEFA76FABC95D7BEC2298FA478FC85888AA868E4EE9756FC6416A4FF9A01C32DE4175C1AB4D9A143CA1E3A72127ADEF497BFA89A5D27F35A75417A820C393623E5B4CA50FBBBCFC441E4BA06D629A8506D865F70AA2429239CD2BB24AB7C90620C9A75868F88CA289E400453EC59CE2EB1D5D89251940914FB1E83545FCA7744BA06EF34936A343BF4AC3D27C3B69F93E59A1E539BF7004DD8EF8C10D343A5A3A86F11A4F63362E0B59D1B1DFC7B19DC6C73EA573B9CBD669859FB35A03F043CF6B8AB458E5E936CD120A96094912E7CB8B632541CE4D33BB082E3904BAFE45D2FB87F23D498A432E405F489AAA77A2CA764836EEFCD71108390CD35B7DB742E1B8F8EEA2418C825E7FBD7F45EE92C3A6EC4331F0C69E90684EF7C32F19C9C53E761FE7A4FDC7D5D7FD75B8783ABB1B5F67095053D048415B50210D6CB20D662030BBA0F8E9DB31E200CEC296816F23C45D1EA8EEA8D82D13D4540C960BED4F64D9C06619C369AA6BA26DBBC22F95A629861044E6248A91E5CF43E8EC252D0C76A7B624BF2EBE2702A68E9F6C68DC48CEACF69B0D9537D9612B5269BED950B9CEF687522473FC6843E723F9F721CD450166BFDB50AB430C426E4E2EC58662E32E6C22E62599D46329D9C659BFD9FD027AECFBEFF6DA5AE13207926D37D094122AA59E4C3C796E99D584C2DEBD8F38B1F4A1F8DC671884864E54BAA2AA3987CB602F8A5D7179365264F1A803507AAA3CF3374DA72DEA4C84C939C97CBC3D7CDFBDFB89EDD9075E66C95136F019D6A1C5A773016A5AA77301A77301ECB739CD4223CD18260102BC270DB1128779434F42A9308592A24686D287DD38AA6C897D55BFA8099884310CBDF6111A4E99281EA65153195FB420034FC2D32CEC3B4D0C949082EA27A34EE28948A6A58DD417942D0B29710CD18AAB94BE11C19D87CC9A06B30876BC9A8B28EFB4136D4006F1024AA59507A2853CF39DE3025F0379F29E541063B3906629004A0441161FC0B097612D05D5E00A05450802C963086D7BF1985BDF1FBFD9DCB6A20B63711BA8FB684EA7E1C54D295DC8E3126CDAB53DDE9BE61BD67E1D7A6DFC94AD09E9AD9939E820347091B7F6E95FCCB1D73B48590C5D751108625D8295652DD372A503AE1EEC8F0CD426BCEC29603EDBE8BEBCFC90AF492EAABFEEF349B20F2C7CE623D3F1776FE4E7ABDC647C62BB3861707CDA5951D33AEDAC9C76564E3B2BD61A3D8A127F4DBF6F5C35B79D6166A554A529F8D8D061E7DF303CBEFA9A25DB74F57DEA6A050FC967A6B173E475F3ACE31C00DDB674965CCE77EBC36A0E706E5B3A472EDFFC7C980187AB564E8ABBB6D74DABEEBADC338DCCE8484B8229460E0B1768EABA787DF89A7C96AF43749F2D96705F9274937C4E3774C03F1E449272AA39E5F769F68F4352238927CA2558D04B1E15F4D8048B3B2E399D9BAEB32F14F5F51B05DC3D1721CD9C6A73739FA7D67EB33916594F9BC04D0636C1E63E0FF37A337FA147F9AC3346CF3FEC5AFB6FC8FB754F6B1770C44558D44D77CFCD76B74D766C73DD7D53BD2D55F140A42AA6995385B59C8B8A0BE9450F18DDB08D322F092A9B607B861C22C8A7CC49F855FEF9796DFD2B23B207589B51CA4E9729C07208E85780DBFDF8D1C21E95DC82B63757DFD571CA3928D65FC6B3C7BAB0E2207FDA84D3D6DAA165C98C64B689161F4B6EA110FAA6B20B971D0AA3FE2BD3D067D72F0F399DE3568248F75F9F84E46C24E53779E9615F738829477D3D3E128551D1CA565F5829657C9639CB5BC0237913F45175E2F7E6719F133A6822D7C00C36DC23EB74451BF5535A1C92CDA79C901B521D264BFF23EA094DD6F1EC94A7E56540752EA316E6A17D6BEF18FD3F8ECE6DA9BB685A75598D0F505ED3769FE7AC47FF95AECB07C14DDA7C32A7F11DE06BFDCEDAD77A45F6624B8E9F2CE49864F7E50318CA55489ABD6EE8803C0B8DD0FBB7238509631DE8F66A012D6DE0CC1795839034A48298265C951B1FE302567A5D4DCCD2D57EFCD2FDDFBDAE767CD98C7B72ADE664F5805ACDC1E2F8CA9AF8D45993657146D9FD255D57CF9CDD7C2D4AB26D907DF3EFCDE526ADA7FC36C3FB244BEF48517EDAFD4CB2978B17CF9EBF589CD5073D9BC7F2EC1F7123EBEDB228D61BE009B78A9FC21D3139C8F1C5F7E4AB381E2D7A3E923BE08ED952181C91C0856CE57565AB26BD5C645F927CF59050B0BC4F1E1BADFE72F1FCC59F16673F1C369B6ADFF5E5E22ED91492D448A4EBAD3284E81F7F6F4DB3DF466EE87EAE4E3659D2E817310D8D34B3A7C158C181B926BF54645E4199CBE73845FABC966A68538D4FCAB4D28376B43A2565438655284662811C2937930FCDF971BD904804424B4A3C213C9E5337964293616FA6CCA024FB53EC61D1CE1C69771776F1183BD2C43F545386A540F2E7D979E2BFDA268FBFB6A5C81F673FCA66F3AD9AECE8AFA27E00F63965676591D0E417F69A983BE1EECE5CFE5CBBBB56170EB3FB29B6F6307B508CCF47F33227537CF42D78B0C55CDB1E8B0756885AE5E542948D171CD6E07132346681464084F9B58A4F7F6D8C0CF87D1163D31BF6861A59DE914CC82810971E2A098BF3EEDD922786725B20C2CF7C588151FDA287312859128171E40020A3C189264DA343681A8A929995DB9F9EB641FBD3D34660C9845E8B07F014446D5E4C43E9847B8EC93E60F741F85CEC034313D8610E3FBEA1E1BE346CDFCFF0A1D0BC9DE143E1F86C860F89FEB90C1F2AEC23193E74A45731DC89B1AF61F8387619379DAFD3477EF0222CAA4F0BBB61F4B6E2E9083B058EBC1161AEC93922914C01E1A989D8B558FB6C9F82D975123059DB3EC96D9998A63BFCD843D899E0B4F773DAFB39EDFD9CF67E6A22A66A1D7F4EC14CB3EB6394EB953B44630EEB60EE9C68586D11C22E6A6F9A9D6CA2183691F29D036BB9F11499182749C4D7112668F50FA0344E0214793B56F3C480E5914834E681C5F14881CE04B11F0998310F889EF6ECE24A131AECDF4C90B471FDF532049098A0F8B4AF0404F6F2B68F060458DA718F06B877B47F2E20409BA22C964E536C4CA5A088C46FA60E90D0FB7A45C0150E6F9DC6A3ABB5771D0E3C31C189C21266E2FD4FCE98388960C7DDA7EF3E8F84A19357FBE4D53E79B52761A88DAECEAD34AEABBDE36AEA8CE2B17EF6C2C162E843B1A8996F44A90BC5E2878510B73C9928C11EE792A4B8C0EE6A810B3F17498571218223D521C60C76E76E1B2F385243B918C2612761EEBA7D688F41F85BD3EDBF710E0A9F4EB2C55F2DF8F8C27D7DE0917DDF6200E1A0164A746D186D191F244A011B6838CA09A6939F20EE113B298AAFA96F000CDD6BE21338160C3CA0EC017C1B19349A26EAA899B12CAA01AC362E40DF3C9C302701E547CE5948E1B88C86821A0933733B17D547010E3B059F40CE434D153DD712EE58905C0BE0F364BE711108B2036EE20632694C202F10188337803359137137480DF194F3E9D04C6C750787B0355472AAA8B5068AAD2F3AB23233DB9171D265667EC126406E246BFBBBB85EC7634CDD48D48528BBEECAFE24EC9223D741DCD138B47A91178A87B55E6348FD0935CD1E7C9A97D472384EC5338D1B651B9968A6DD546D3B59EB50EB33EC4F28946F94E5D0E4B69D9DB7C93C54C9BB34FB99AC9F2064BA8EC55AAD708C8B355ECC8522816555C4C05B583552389E7DDC6D7A255647173CB6AF0A247ECE7DAFE3B1EC37E98AD64F9B2A45EFFF905D910D29C9597528A2B2202F936295C8CFD0567D58232DE9638C0B4D6112F8B6FC46AA82C28E54FB3E74B54C97E7459927A91C319E2E7FB355BA4F36001784BC76B346D5C78EB898D204A2A95E1F007AEC5D6D475D60B98E21174B064216C8E2C3806300B31FD667E7E7CFA59185693661EF07878BF5C0299F8270044CDD6F93BAE570EDA362873BD37B6B0C1F708865CDA4C70C7FAA19A22AE4888AA031D0839CEB766AC030E061837E9ACE6AD08C6689192EE22940AE4F8B39310D3B29A9A3BCBAD43C1C3C6E19F3B808810DCD34C454C751E3BE3F1158B07D9A0324DA16855415867000B1F0E480302F14F0D1AC9460B01A4263ED2018A89121613540ED9760DAC1CA28C56B1F101F5DB8C0DBB01089B454969A0D3686497D724053C4CC74AA7C409C358B1E20B49E166EF272055DA618EAA6BAAC5241C55C00D92F42B8128160D4F7DF5E6921ED187466639BA3B67AA7A4B62CB1FC04D4953DCA470716F36EC1BC2645F6F907C5AAEC495B600A2B778E78935FF7F25A7C7F33C0335DA40BDB8923C24FD9820110C87C69BD05C065EC7EBCEB4476809B0FE66E453606234B87FB1E052072BF14E302DF2AB7828432D2A47595C362A0BE2F77CB7C501B5552245AC5681E1307D146E3810B8FCBAB18757D20DEA8A033AB7E000056E8BF155BA3469EA10E8A8D307BD4CF5B9199E37A546D568329C2C90F8D57C10894B33EB1610CBBB11DDF5054D8199E05E2020B407BF57C862784347D98E199212FC2292193E31E1341D0A8C7855C3034EE798F7602939A3F4D8B684A601BD2327206D8A8D69110ED39E49A3F0ABAC418D96C33A4B4D9630A8D083E4538D5BAAA0B1C3C4D05D54754161B70FC3A7BD82862464F1530D229D8496B20391AB0D8902136F0868693FDE6DDE8B09AD9CEC9900E83F1F6468C713B85CD107ED9D646678BB717A234999F98A96CBF066323E38D0F853E98DE6467A8138C94679646C5511D6B66F2364E13C9909F0FEB2FB3C70C10A3D1BAB2A160528524BAAD7F6147D9DA9076D268355F9F205E1461FC14E388C4ED8B841C4D8D43C2A78FBA36A30D0F28821D886E36FD096D776823F8B9D43E12EA54213727A9C12681B911B59B03E6C6D7757C749FDB6ACC7A92B76FF35DB7FB5FDFD4FFB4BB45E301792A44F5E24EA895A52826191C3498913AC3D8ED52F18077680DC034308A7C6F68CE083733034CBDF9A7424C1F29A481CC4807008C024704C5CDA87BFDF3D8DFEFB0C3B83C9F23E692B5C3BA1ED028569315AE66EFBBB682D514FCD77CD02D23DD8406388BA8A1847A599262D253D35618CB9D6A1E1E596D9C14FA55ADB9A6E3607006DBACDD0A0E3893A2024E046CF50F2DDA82875A9B006EE6A2A1E4788F0340E74D1D14929629690992B74CD8ADC9DB342FAAE0A5C9678975C752749E0602FB2DCEDE74812641FCDCAC1EC83679B9587FDE513C34F12AF91C129AE0DA844323CA6A857C58FD42564D43380352AA9E4B852AE532E8FBDC6B7CA8A77DAAA27F7D06B3AAFAC864AAEAFA1C48957D267366F6D75C31A6F6B934CCED331A3601A917AFCCB80626B68AB22A260F562793CDB07295BC18C8899D7CC897B9A43AE52C50B5722EF39AF14AB5F5196B23FEA4805219F1D9305DC4E7D4B4423AC82B3540CA01D52D65D254CB1C01952A64D2A0AA9864834A74D805F2A82AB5C370738400AC4F5D851155042C7A905881E3B8B30C087CFD1D16F43AC98470B3E504136FD2941534C9A695B0FB48EAEAD85C68C56C465D13BA1773808AFB34B0BA3E595309F7E4B2540D970A55C465D05425EE9E48B58919A00AC53C666685DA9C40CD0863358CA85E5CDD6A6B10D72B523D6206A836318F502733F1C0D675B77972C66405CC6C789345ED5CE83A8BDA8AC8729127A036E6977C176DBB2F440DD771010B32EEDF19258526245A7C9648D700B45C5194D0770BEC8E1143C0A99B2383CFC84EEC01C33DC37CD1478686B7136591D1B1035A56B1E5956B256716F0218DD5FD47421F07E93CB052AECB624B60FB4E7701A0900197F2C4EB2CD8D390DD14A2D262BDC502D8BA375E31C682F28BD07520E02AD27B5D78D6C00C9016F71C09F57ADD9D1DEAB8A008570C8389825D947539AAC3D5349460093517F412C0120675A12A6B4CAC5832D28301604046840BFA008EC1F586E4F813E788089A441537D09233C0D6BADFF4370116A902DB01AC318A81C77589F5ABD47D80FC265C09C0A75717C49C755E9D0622B9E15DD7857E537587738E8A7D021D9E23304611610CE088492CB27058B0679E6BE711AB521D312BE892DB88511EEB4930DC13B29AD487878AE27180BCA7DC8212F58E86638F76B56D10C42892176268162111771071D1C5E7F1D4126331038B100370C338A08C273B147B447561DDC68F232298B8262A18A8429F787656DA99EA8AC19B4E6E1D94DC69D8385B04EE08D079F50A43BF09E638DA1AFB198F3011D4608E35512AC21B283AAB0B8410609441B51641B74317F975BD56DDF99F49B7E57BE7E09A10BD9CEED9556EE3F62800D0BEAC63E7D8DBD2AABE296F54CB0D653782FBC6427BBC4377F2957CA717EB2F903D9E518B6C6FF34C44F6ABC3B086192E33E628EF5D8644C6E0ACF1BE1D09702FEC8DCBA0F883CF02D424343BFCEEBB52169704913D2BD7AB86A1D7A4A69B441E2B4FBB4B72C88AD4E3B65DA495AAD1C6B20FEBB83B62186BD497C982DAA6B13BEE7F85096052E07B5181B1041FCDA969680EDC78B3B7DDBAAF6F56E819C7658FA795C6650873D7C48823AABB2933404975698ABB41D1A55D2C9BF35FC70FF4DF729727F7E4FD6E4D3645FDF562F9F1404B6F49F3DF15A9AC988EC405A59991FACE564FB4CD739DDDED1885C3B6A8CDD2261F87E93D29933585CFABBC4CEF9255B551446DFAA23E99587B015E2EDE6C3F93F575F6E150EE0F954D45B69F371C33AA0B2858FD174BA9CD171FF6B5632F4417683353DA05F2217B7DA00BEAAEDD6F938D38F42A12D5CD96BF13FABD194BAABFE8907FED28FDB0CB0C091DD9D75DC8F944B67BBAF424C587EC26F942D46DD3F390E7D8C5559ADCE7C9B638D2E8CBD37F29FCD6DBC7BFFE3F77CB17BD9F500200 , N'6.0.2-21211')