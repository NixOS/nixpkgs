# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qt3d-everywhere-src-5.12.4.tar.xz";
      sha256 = "cfad2e16f40fa07f8be59fa29c0c246743ee67db417ca29772a92f36fa322af3";
      name = "qt3d-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtactiveqt-everywhere-src-5.12.4.tar.xz";
      sha256 = "d3c78e6c2a75b9d4f9685d4eea6e84f44f97034a54aed7a159c53cfd4ec4eac7";
      name = "qtactiveqt-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtandroidextras-everywhere-src-5.12.4.tar.xz";
      sha256 = "18e0dbd82920b0ca51b29172fc0ed1f2a923cb7c4fa8fb574595abc16ec3245e";
      name = "qtandroidextras-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtbase-everywhere-src-5.12.4.tar.xz";
      sha256 = "20fbc7efa54ff7db9552a7a2cdf9047b80253c1933c834f35b0bc5c1ae021195";
      name = "qtbase-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtcanvas3d-everywhere-src-5.12.4.tar.xz";
      sha256 = "d7e0e8aa542d077a929fb7700411ca9de1f65ae4748d64168d2e7533facd7869";
      name = "qtcanvas3d-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtcharts-everywhere-src-5.12.4.tar.xz";
      sha256 = "06ff68a80dc377847429cdd87d4e46465e1d6fbc417d52700a0a59d197669c9e";
      name = "qtcharts-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtconnectivity-everywhere-src-5.12.4.tar.xz";
      sha256 = "749d05242b9fae12e80f569fb6b918dc011cb191eeb05147cbde474ca6b173ef";
      name = "qtconnectivity-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtdatavis3d-everywhere-src-5.12.4.tar.xz";
      sha256 = "1c160eeb430c8602aaee8ae4faa55bc62f880dae642be5fd1ac019f7886eb15a";
      name = "qtdatavis3d-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtdeclarative-everywhere-src-5.12.4.tar.xz";
      sha256 = "614105ed73079d67d81b34fef31c9934c5e751342e4b2e0297128c8c301acda7";
      name = "qtdeclarative-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtdoc-everywhere-src-5.12.4.tar.xz";
      sha256 = "93e6cb6abc0dad3a831a6e2c46d950bd7a99b59d60ce2d2b81c2ce893bfb41bb";
      name = "qtdoc-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtgamepad-everywhere-src-5.12.4.tar.xz";
      sha256 = "25de6f10fb18f2484d1e569688bf33deb90ecbfb97ce41c2b5fb3521146e4c45";
      name = "qtgamepad-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtgraphicaleffects-everywhere-src-5.12.4.tar.xz";
      sha256 = "0bc38b168fa724411984525173d667aa47076c8cbd4eeb791d0da7fe4b9bdf73";
      name = "qtgraphicaleffects-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtimageformats-everywhere-src-5.12.4.tar.xz";
      sha256 = "2dee25c3eea90d172cbd40f41450153322b902da1daa7d2370a55124b2307bb3";
      name = "qtimageformats-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtlocation-everywhere-src-5.12.4.tar.xz";
      sha256 = "127b40bd7679fead3fb98f4c9c1d71dde9d6d416e90a6000129b61a5f128b3a0";
      name = "qtlocation-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtmacextras-everywhere-src-5.12.4.tar.xz";
      sha256 = "3ea0b94f9b63e801f2ddafa2a908002d9529a3c65021d261627d21e07454acde";
      name = "qtmacextras-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtmultimedia-everywhere-src-5.12.4.tar.xz";
      sha256 = "7c0759ab6fca2480b10b71a35beeffe0b847adeff5af94eacd1a4531d033423d";
      name = "qtmultimedia-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtnetworkauth-everywhere-src-5.12.4.tar.xz";
      sha256 = "e501eb46b8405a2b7db9fe90a1c224cf6676a07dc22c0662317ffe3dee1dbf55";
      name = "qtnetworkauth-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtpurchasing-everywhere-src-5.12.4.tar.xz";
      sha256 = "7804a111043d0e8d6d81a0d0ae465ce2c36eca73f2774ccb5fa7be8670211672";
      name = "qtpurchasing-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtquickcontrols-everywhere-src-5.12.4.tar.xz";
      sha256 = "32d4c2505337c67b0bac26d7f565ec8fabdc616e61247e98674820769dda9858";
      name = "qtquickcontrols-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtquickcontrols2-everywhere-src-5.12.4.tar.xz";
      sha256 = "9a447eed38bc8c7d7be7bc407317f58940377c077ddca74c9a641b1ee6200331";
      name = "qtquickcontrols2-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtremoteobjects-everywhere-src-5.12.4.tar.xz";
      sha256 = "54dd0c782abff90bf0608771c2e90b36073d9bd8d6c61706a2873bb7c317f413";
      name = "qtremoteobjects-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtscript-everywhere-src-5.12.4.tar.xz";
      sha256 = "7adb3fe77638c7a6f2a26bca850b0ff54f5fb7e5561d2e4141d14a84305c2b6a";
      name = "qtscript-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtscxml-everywhere-src-5.12.4.tar.xz";
      sha256 = "696fb72a62018151275fe589fc80cb160d2becab9a3254321d40e2e11a0ad4f8";
      name = "qtscxml-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtsensors-everywhere-src-5.12.4.tar.xz";
      sha256 = "95873c7ea5960008d6eb41368ca64d68fbd05594ca8c2cd848b1612fc4aec0a9";
      name = "qtsensors-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtserialbus-everywhere-src-5.12.4.tar.xz";
      sha256 = "69d56905f43ee13e670750e8f46d373835fae81d6343baa7c4004d2a2c6311fc";
      name = "qtserialbus-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtserialport-everywhere-src-5.12.4.tar.xz";
      sha256 = "bf487df8a9fb2eddf103842b57a75b17ef4c498ee40306ae9997017c82b0ad39";
      name = "qtserialport-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtspeech-everywhere-src-5.12.4.tar.xz";
      sha256 = "2ff9660fb3f5663c9161f491d1a304db62691720136ae22c145ef6a1c94b90ec";
      name = "qtspeech-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtsvg-everywhere-src-5.12.4.tar.xz";
      sha256 = "110812515a73c650e5ebc41305d9a243dadeb21f485aaed773e394dd84ce0d04";
      name = "qtsvg-everywhere-src-5.12.4.tar.xz";
    };
  };
  qttools = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qttools-everywhere-src-5.12.4.tar.xz";
      sha256 = "3b0e353860a9c0cd4db9eeae5f94fef8811ed7d107e3e5e97e4a557f61bd6eb6";
      name = "qttools-everywhere-src-5.12.4.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qttranslations-everywhere-src-5.12.4.tar.xz";
      sha256 = "ab8dd55f5ca869cab51c3a6ce0888f854b96dc03c7f25d2bd3d2c50314ab60fb";
      name = "qttranslations-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtvirtualkeyboard-everywhere-src-5.12.4.tar.xz";
      sha256 = "33ac0356f916995fe5a91582e12b4c4f730c705808ea3c14e75c6e350e8131e6";
      name = "qtvirtualkeyboard-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwayland-everywhere-src-5.12.4.tar.xz";
      sha256 = "2fade959c3927687134c597d85c12ba1af22129a60ab326c2dc77a648e74e6b7";
      name = "qtwayland-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwebchannel-everywhere-src-5.12.4.tar.xz";
      sha256 = "ab571a1b699e61a86be1a6b8d6ffd998d431c4850cc27e9a21f81fa5923bfdb7";
      name = "qtwebchannel-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwebengine-everywhere-src-5.12.4.tar.xz";
      sha256 = "fccf5c945412c19c3805323211b504ac8becbf191c638a2dc85ec91abfb1b331";
      name = "qtwebengine-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwebglplugin-everywhere-src-5.12.4.tar.xz";
      sha256 = "756fa09893618029bb56605be3ac5756a1834255fb223f8e4b7de205846d3266";
      name = "qtwebglplugin-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwebsockets-everywhere-src-5.12.4.tar.xz";
      sha256 = "b471eda2f486d21c51fc3bc53bb8844022117e746d5f15c5eabb82cd37eb2abe";
      name = "qtwebsockets-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwebview-everywhere-src-5.12.4.tar.xz";
      sha256 = "1f244c6b774dd9d03d3c5cafe877381900b50a2775cef6487c8bb66e32ab5a5d";
      name = "qtwebview-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtwinextras-everywhere-src-5.12.4.tar.xz";
      sha256 = "f6e0172582a499d5e50c51877552d1a3bff66546d9a02e5754100a51b192973f";
      name = "qtwinextras-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtx11extras-everywhere-src-5.12.4.tar.xz";
      sha256 = "49cc009eaf4a01ca7dbe12651ef39de9a43860acb674aec372e70b209f9bae1e";
      name = "qtx11extras-everywhere-src-5.12.4.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.4";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.4/submodules/qtxmlpatterns-everywhere-src-5.12.4.tar.xz";
      sha256 = "0bea1719bb948f65cbed4375cc3e997a6464f35d25b631bafbd7a3161f8f5666";
      name = "qtxmlpatterns-everywhere-src-5.12.4.tar.xz";
    };
  };
}
