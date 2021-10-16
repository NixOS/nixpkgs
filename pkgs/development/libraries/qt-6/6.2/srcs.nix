# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/6.2
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qt3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "03ed6a48c813c75296c19f5d721184ab168280b69d2656cf16f877d3d4c55c1d";
      name = "qt3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtactiveqt-everywhere-src-6.2.0.tar.xz";
      sha256 = "868161fee0876d17079cd5bed58d1667bf19ffd0018cbe515129f11510ad2a5c";
      name = "qtactiveqt-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtandroidextras = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtandroidextras-everywhere-src-6.2.0.tar.xz";
      sha256 = "5813278690d89a9c232eccf697fc280034de6f9f02a7c40d95ad5fcf8ac8dabd";
      name = "qtandroidextras-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtbase-everywhere-src-6.2.0.tar.xz";
      sha256 = "909fad2591ee367993a75d7e2ea50ad4db332f05e1c38dd7a5a274e156a4e0f8";
      name = "qtbase-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtcharts-everywhere-src-6.2.0.tar.xz";
      sha256 = "e0750e4195bd8a8b9758ab4d98d437edbe273cd3d289dd6a8f325df6d13f3d11";
      name = "qtcharts-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtconnectivity-everywhere-src-6.2.0.tar.xz";
      sha256 = "0380327871f76103e5b8c2a305988d76d352b6a982b3e7b3bc3cdc184c64bfa0";
      name = "qtconnectivity-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdatavis3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "226a6575d573ad78aca459709722c496c23aee526aa0c38eb7c93b0bea1eb6fd";
      name = "qtdatavis3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdeclarative-everywhere-src-6.2.0.tar.xz";
      sha256 = "c600d09716940f75d684f61c5bdaced797f623a86db1627da599027f6c635651";
      name = "qtdeclarative-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdoc-everywhere-src-6.2.0.tar.xz";
      sha256 = "a47809f00f1bd690ca4e699cb32ffe7717d43da84e0167d1f562210da7714ce4";
      name = "qtdoc-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtgamepad = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtgamepad-everywhere-src-6.2.0.tar.xz";
      sha256 = "c77611f7898326d69176ad67a9b886f617cdedc368ec29f223d63537d25b075c";
      name = "qtgamepad-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtgraphicaleffects-everywhere-src-6.2.0.tar.xz";
      sha256 = "ec8d67f64967d5046410490b549c576f9b9e8b47ec68594ae84aa8870173dfe4";
      name = "qtgraphicaleffects-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtimageformats-everywhere-src-6.2.0.tar.xz";
      sha256 = "bf8285c7ce04284527ab823ddc7cf48a1bb79131db3a7127342167f4814253d7";
      name = "qtimageformats-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtlocation-everywhere-src-6.2.0.tar.xz";
      sha256 = "984fcb09e108df49a8dac35d5ce6dffc49caafd2acb1c2f8a5173a6a21f392a0";
      name = "qtlocation-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtlottie-everywhere-src-6.2.0.tar.xz";
      sha256 = "cec6095ab8f714e609d2ad3ea8c4fd819461ce8793adc42abe37d0f6dc432517";
      name = "qtlottie-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtmacextras = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtmacextras-everywhere-src-6.2.0.tar.xz";
      sha256 = "6959b0f2cec71cd66800f36cab797430860e55fa33c9c23698d6a08fc2b8776e";
      name = "qtmacextras-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtmultimedia-everywhere-src-6.2.0.tar.xz";
      sha256 = "0c3758810e5131aabcf76e4965e4c18b8911af54d9edd9305d2a8278d8346df5";
      name = "qtmultimedia-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtnetworkauth-everywhere-src-6.2.0.tar.xz";
      sha256 = "fcc2ec42faa68561efa8f00cd72e662fbc06563ebc6de1dc42d96bb2997acd85";
      name = "qtnetworkauth-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtpurchasing = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtpurchasing-everywhere-src-6.2.0.tar.xz";
      sha256 = "87120d319ff2f8106e78971f7296d72a66dfe91e763d213199aea55046e93227";
      name = "qtpurchasing-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquick3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "5b0546323365ce34e4716f22f305ebb4902e222c1a0910b65ee448443c2f94bb";
      name = "qtquick3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquickcontrols-everywhere-src-6.2.0.tar.xz";
      sha256 = "c393fb7384b1f047f10e91a6832cf3e6a4c2a41408b8cb2d05af2283e8549fb5";
      name = "qtquickcontrols-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquickcontrols2-everywhere-src-6.2.0.tar.xz";
      sha256 = "671b6ce5f4b8ecc94db622d5d5fb29ef4ff92819be08e5ea55bfcab579de8919";
      name = "qtquickcontrols2-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquicktimeline-everywhere-src-6.2.0.tar.xz";
      sha256 = "b9c247227607437acec7c7dd18ad46179d20369c9d22bdb1e9fc128dfb832a28";
      name = "qtquicktimeline-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtremoteobjects-everywhere-src-6.2.0.tar.xz";
      sha256 = "6781b6bc90888254ea77ce812736dac00c67fa4eeb3095f5cd65e4b9c15dcfc2";
      name = "qtremoteobjects-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtscript = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtscript-everywhere-src-6.2.0.tar.xz";
      sha256 = "a299715369afbd1caa4d7fa2875d442eab91adcaacafce54a36922442624673e";
      name = "qtscript-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtscxml-everywhere-src-6.2.0.tar.xz";
      sha256 = "60b9590b9a41c60cee7b8a8c8410ee4625f0389c1ff8d79883ec5a985638a7dc";
      name = "qtscxml-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtsensors-everywhere-src-6.2.0.tar.xz";
      sha256 = "3f0011f9e9942cad119146b54d960438f4568a22a274cdad4fae06bb4e0e4839";
      name = "qtsensors-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtserialbus-everywhere-src-6.2.0.tar.xz";
      sha256 = "aeeb7e5c0d3f8503215b22e1a84c0002ca67cf63862f6e3c6ef44a67ca31bd88";
      name = "qtserialbus-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtserialport-everywhere-src-6.2.0.tar.xz";
      sha256 = "59c559d748417306bc1b2cf2315c1e63eed011ace38ad92946af71f23e2ef79d";
      name = "qtserialport-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtspeech-everywhere-src-6.2.0.tar.xz";
      sha256 = "c810fb9eecb08026434422a32e79269627f3bc2941be199e86ec410bdfe883f5";
      name = "qtspeech-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtsvg-everywhere-src-6.2.0.tar.xz";
      sha256 = "8bc3c2c1bc2671e9c67d4205589a8309b57903721ad14c60ea21a5d06acb585e";
      name = "qtsvg-everywhere-src-6.2.0.tar.xz";
    };
  };
  qttools = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qttools-everywhere-src-6.2.0.tar.xz";
      sha256 = "c189d0ce1ff7c739db9a3ace52ac3e24cb8fd6dbf234e49f075249b38f43c1cc";
      name = "qttools-everywhere-src-6.2.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qttranslations-everywhere-src-6.2.0.tar.xz";
      sha256 = "d5788e86257b21d5323f1efd94376a213e091d1e5e03b45a95dd052b5f570db8";
      name = "qttranslations-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtvirtualkeyboard-everywhere-src-6.2.0.tar.xz";
      sha256 = "9a3193913be30f09a896e3b8c2f9696d2e9b3f88a63ae9ca8c97a2786b68cf55";
      name = "qtvirtualkeyboard-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwayland-everywhere-src-6.2.0.tar.xz";
      sha256 = "193732229ff816f3aaab9a5e2f6bed71ddddbf1988ce003fe8dd84a92ce9aeb5";
      name = "qtwayland-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebchannel-everywhere-src-6.2.0.tar.xz";
      sha256 = "127fe79c43b386713f151ed7d411cd81e45e29f9c955584f29736f78c9303ec1";
      name = "qtwebchannel-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebengine-everywhere-src-6.2.0.tar.xz";
      sha256 = "c8afca0e43d84f7bd595436fbe4d13a5bbdb81ec5104d605085d07545b6f91e0";
      name = "qtwebengine-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebglplugin-everywhere-src-6.2.0.tar.xz";
      sha256 = "81e782b517ed29e10bea1aa90c9f59274c98a910f2c8b105fa78368a36b41446";
      name = "qtwebglplugin-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebsockets-everywhere-src-6.2.0.tar.xz";
      sha256 = "a0b42d85dd34ff6e2d23400e02f83d8b85bcd80e60efd1521d12d9625d4a233f";
      name = "qtwebsockets-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebview-everywhere-src-6.2.0.tar.xz";
      sha256 = "be9f46167e4977ead5ef5ecf883fdb812a4120f2436383583792f65557e481e7";
      name = "qtwebview-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwinextras = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwinextras-everywhere-src-6.2.0.tar.xz";
      sha256 = "65b8272005dec00791ab7d81ab266d1e3313a3bbd8e54e546d984cf4c4ab550e";
      name = "qtwinextras-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtx11extras = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtx11extras-everywhere-src-6.2.0.tar.xz";
      sha256 = "7014702ee9a644a5a93da70848ac47c18851d4f8ed622b29a72eed9282fc6e3e";
      name = "qtx11extras-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtxmlpatterns-everywhere-src-6.2.0.tar.xz";
      sha256 = "76ea2162a7c349188d7e7e4f6c77b78e8a205494c90fee3cea3487a1ae2cf2fa";
      name = "qtxmlpatterns-everywhere-src-6.2.0.tar.xz";
    };
  };
}
