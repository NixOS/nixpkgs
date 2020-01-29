# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qt3d-everywhere-src-5.12.6.tar.xz";
      sha256 = "cf34ce99a2592270abbf32a13fa824d99c76412fc493a3f1c37e37892b198baf";
      name = "qt3d-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtactiveqt-everywhere-src-5.12.6.tar.xz";
      sha256 = "c50f082588bf7dad2091a5b67c426791bf36d7d1503c56dc79b9e26444931f09";
      name = "qtactiveqt-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtandroidextras-everywhere-src-5.12.6.tar.xz";
      sha256 = "a0f15a4ba29abe90de2b2c221efd22ecfb6793590ff9610f85e6e6b6562784fe";
      name = "qtandroidextras-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtbase-everywhere-src-5.12.6.tar.xz";
      sha256 = "6ab52649d74d7c1728cf4a6cf335d1142b3bf617d476e2857eb7961ef43f9f27";
      name = "qtbase-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtcanvas3d-everywhere-src-5.12.6.tar.xz";
      sha256 = "2d33e6c944e5a2eed7528fdfe9deadfb1b7a0fcf17bab1f8b83988b1327d9d08";
      name = "qtcanvas3d-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtcharts-everywhere-src-5.12.6.tar.xz";
      sha256 = "14dbdb5bb18d774e3b7ac3042a3f349080ab42c2588527ff04123df1c9ccaa3d";
      name = "qtcharts-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtconnectivity-everywhere-src-5.12.6.tar.xz";
      sha256 = "10f1c6727aedc375a1bfab4bb33fd2111bf2c1dfc19049e361c0f58608ea22da";
      name = "qtconnectivity-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtdatavis3d-everywhere-src-5.12.6.tar.xz";
      sha256 = "414d91aae5e7d3404a0b526f944961871b1abf1fda51f0861d19cb28a2eba4fe";
      name = "qtdatavis3d-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtdeclarative-everywhere-src-5.12.6.tar.xz";
      sha256 = "34b1d1ae5562f1d433e22c255ac1a37a2fb030ef05bf6123d4b9496644b686d3";
      name = "qtdeclarative-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtdoc-everywhere-src-5.12.6.tar.xz";
      sha256 = "82549278120236ece0e02f9bab351319e4469c242ce97b05f269964aee924aac";
      name = "qtdoc-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtgamepad-everywhere-src-5.12.6.tar.xz";
      sha256 = "e1ebc5f3593c5234724663106790fbf1831d4ac8ea50a9d9805d2dd0a1c5b3b3";
      name = "qtgamepad-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtgraphicaleffects-everywhere-src-5.12.6.tar.xz";
      sha256 = "ded0327624a13bf7fab07e5fe762473194ed898b0442ef9325498e41c8c077ef";
      name = "qtgraphicaleffects-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtimageformats-everywhere-src-5.12.6.tar.xz";
      sha256 = "330d1c29a135c44bb36b5ffc2ba4f8915dbc446d5d75563523ebcfd373617858";
      name = "qtimageformats-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtlocation-everywhere-src-5.12.6.tar.xz";
      sha256 = "7ae231ca4de3c0915e92bb95440b0ddc7113790b1acb536c9394472e8dde2278";
      name = "qtlocation-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtmacextras-everywhere-src-5.12.6.tar.xz";
      sha256 = "eae25b8858fef348667b938f5c88a014ee78945c419e4e6d856d4a6adc5e43a3";
      name = "qtmacextras-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtmultimedia-everywhere-src-5.12.6.tar.xz";
      sha256 = "9f580e8962ca6a09608570e77b38d7c3f71d344ff6de1c39bc6905226b679570";
      name = "qtmultimedia-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtnetworkauth-everywhere-src-5.12.6.tar.xz";
      sha256 = "ea122d86a960863bbe0e0f4b5a12f0a376455beed3c26f1b61926e065b366abd";
      name = "qtnetworkauth-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtpurchasing-everywhere-src-5.12.6.tar.xz";
      sha256 = "1fa0b7e3da4755b64559177f507718320c1aa9e66ec49e17595e04c3f3af70cd";
      name = "qtpurchasing-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtquickcontrols-everywhere-src-5.12.6.tar.xz";
      sha256 = "c48d96a187ff924f1ae4b4abe9cc073adeb06a6c2b07c4191aa595ad22df2c99";
      name = "qtquickcontrols-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtquickcontrols2-everywhere-src-5.12.6.tar.xz";
      sha256 = "5cab0712f946405db269851b96cca02ef8ba98f3ee2c4fa9c0877dba3808a970";
      name = "qtquickcontrols2-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtremoteobjects-everywhere-src-5.12.6.tar.xz";
      sha256 = "49b5353d020fb6ab9bdf90c941a4b3acc6b036266f6c68a42fc44a7ac151d699";
      name = "qtremoteobjects-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtscript-everywhere-src-5.12.6.tar.xz";
      sha256 = "a18082ad338e2378cccab932045804ad3077ec924fed2efc59d4b726d622777c";
      name = "qtscript-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtscxml-everywhere-src-5.12.6.tar.xz";
      sha256 = "53d7837c8b5b1f9beb26cb64ea4334211218533e0126167e4e7e75238f7ac68b";
      name = "qtscxml-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtsensors-everywhere-src-5.12.6.tar.xz";
      sha256 = "59dba4c0bc72846d938e0862f14d8064fb664d893f270a41d3abf4e871290ef5";
      name = "qtsensors-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtserialbus-everywhere-src-5.12.6.tar.xz";
      sha256 = "071b421282118c507a996e3cee4070f2c545335dfd891a44bf54100935cff5de";
      name = "qtserialbus-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtserialport-everywhere-src-5.12.6.tar.xz";
      sha256 = "77d0def93078fb5d9de6faa9ccff05cce5b934899e856b04bcf7f721a4e190be";
      name = "qtserialport-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtspeech-everywhere-src-5.12.6.tar.xz";
      sha256 = "27ae7b2c7073377a617f32b0f4adfc1807774f02d13469ed4bcd282799cf878a";
      name = "qtspeech-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtsvg-everywhere-src-5.12.6.tar.xz";
      sha256 = "46243e6c425827ab4e91fbe31567f683ff14cb01d12f9f7543a83a571228ef8f";
      name = "qtsvg-everywhere-src-5.12.6.tar.xz";
    };
  };
  qttools = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qttools-everywhere-src-5.12.6.tar.xz";
      sha256 = "e94991c7885c2650cefd71189873e45b1d64d6042e439a0a0d9652c191d3c777";
      name = "qttools-everywhere-src-5.12.6.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qttranslations-everywhere-src-5.12.6.tar.xz";
      sha256 = "798ac44414206898d0192653118de3f115c59016e2bf82ad0c659f9f8c864768";
      name = "qttranslations-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtvirtualkeyboard-everywhere-src-5.12.6.tar.xz";
      sha256 = "04699888d6e1e8e04db8043a37212fa3b1fcb1b23aef41c2f3ae7a4278e34d2c";
      name = "qtvirtualkeyboard-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwayland-everywhere-src-5.12.6.tar.xz";
      sha256 = "fa9c6aa84ddc0334b44f0f47d69569e496e5d9f3a1ed67aab42214854d2351c4";
      name = "qtwayland-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwebchannel-everywhere-src-5.12.6.tar.xz";
      sha256 = "2745d1703de1a749405727a74786184c950ba7465dc5d02e2f39f51635dbc8d7";
      name = "qtwebchannel-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwebengine-everywhere-src-5.12.6.tar.xz";
      sha256 = "caa5f257c3bc33c1d2fcb9b7cd414fd5c46e8eee8a103231ab28d592a0058621";
      name = "qtwebengine-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwebglplugin-everywhere-src-5.12.6.tar.xz";
      sha256 = "21d88852f69f0f06c5899e61fe76b2cefc2b65be4ed3c334ec01431ba16f50dd";
      name = "qtwebglplugin-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwebsockets-everywhere-src-5.12.6.tar.xz";
      sha256 = "f00bfbaa73e60a4c3371e729167d7acb465cbb2db32535d745982cab21fed61e";
      name = "qtwebsockets-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwebview-everywhere-src-5.12.6.tar.xz";
      sha256 = "42c0623c1c066620ab1afc3736a4a5f42115f9c190dafdf643e16ccec6e7727a";
      name = "qtwebview-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtwinextras-everywhere-src-5.12.6.tar.xz";
      sha256 = "02c2b2393073a22498a5645faed34040428ace9cf09f18e2f12e75e31be54bea";
      name = "qtwinextras-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtx11extras-everywhere-src-5.12.6.tar.xz";
      sha256 = "5f3991f557116034731ed059895e73b5d34e1b22e85536a8eb6e92350b3a1d6b";
      name = "qtx11extras-everywhere-src-5.12.6.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.6";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.6/submodules/qtxmlpatterns-everywhere-src-5.12.6.tar.xz";
      sha256 = "76977bc834e6c6118ae2bab31e68ae54843358936b03e432d919ad15cd2184d0";
      name = "qtxmlpatterns-everywhere-src-5.12.6.tar.xz";
    };
  };
}
