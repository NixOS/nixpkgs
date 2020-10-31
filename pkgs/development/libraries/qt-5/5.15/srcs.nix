# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.15
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qt3d-everywhere-src-5.15.1.tar.xz";
      sha256 = "29aac2c38b6b2fb1e7d54829ff8b4c9aae12a70ffab9707c7388f1e134dd9411";
      name = "qt3d-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtactiveqt-everywhere-src-5.15.1.tar.xz";
      sha256 = "4f8bbd320349d89ae7867de4bc752cf984f96c6def2b951564dcd5e4f53529c1";
      name = "qtactiveqt-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtandroidextras-everywhere-src-5.15.1.tar.xz";
      sha256 = "c1e64d7278f38d99a672265feb8ba5f3edcc9377e816d055a4150f2c44dc58ed";
      name = "qtandroidextras-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtbase = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtbase-everywhere-src-5.15.1.tar.xz";
      sha256 = "33960404d579675b7210de103ed06a72613bfc4305443e278e2d32a3eb1f3d8c";
      name = "qtbase-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtcharts = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtcharts-everywhere-src-5.15.1.tar.xz";
      sha256 = "a59efbf095bf8a62c29f6fe90a3e943bbc7583d1d2fed16681675b923c45ef3b";
      name = "qtcharts-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtconnectivity-everywhere-src-5.15.1.tar.xz";
      sha256 = "53c30039d4f2301a1a66c646690436e1f8cce0a3fd212ca0783f346a115d8016";
      name = "qtconnectivity-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtdatavis3d-everywhere-src-5.15.1.tar.xz";
      sha256 = "89ed596ea452a8dd8223d094690606bcccc92962776584aceefcc13f56538c06";
      name = "qtdatavis3d-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtdeclarative-everywhere-src-5.15.1.tar.xz";
      sha256 = "7e30f0ccba61f9d71720b91d7f7523c23677f23cd96065cb71df1b0df329d768";
      name = "qtdeclarative-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtdoc = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtdoc-everywhere-src-5.15.1.tar.xz";
      sha256 = "f71b37b050f530c066fab49acb8dacf3d6c99cdef6af1f5ef6c1cbf6d3f87451";
      name = "qtdoc-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtgamepad-everywhere-src-5.15.1.tar.xz";
      sha256 = "87ffcd5cd5588a0114b7ec76d9de5d486154a0833cd11f400c414d07402eb452";
      name = "qtgamepad-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtgraphicaleffects-everywhere-src-5.15.1.tar.xz";
      sha256 = "f4a4d3e1c6d8b0b200b6759ebb615344275957d56d2ef6a33641f853120466d1";
      name = "qtgraphicaleffects-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtimageformats-everywhere-src-5.15.1.tar.xz";
      sha256 = "75e72b4c11df97af3ff64ed26df16864ce1220a1cc730e49074ab9d72f658568";
      name = "qtimageformats-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtlocation = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtlocation-everywhere-src-5.15.1.tar.xz";
      sha256 = "093af763a70d126c4b9f6a22ebf8218fe95dc0151e40666b2389fdf55c9f1a2c";
      name = "qtlocation-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtlottie = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtlottie-everywhere-src-5.15.1.tar.xz";
      sha256 = "845987860c7990035a7cd9a0e7581d210f786e551882df8b5be69f08987f2ba0";
      name = "qtlottie-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtmacextras-everywhere-src-5.15.1.tar.xz";
      sha256 = "6bbcbb95bd854fc5325257c797379bd66cd5f0601ccca2ab6a2af5610d113f62";
      name = "qtmacextras-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtmultimedia-everywhere-src-5.15.1.tar.xz";
      sha256 = "ed6e75bec9c98559c0fbc91ff746185b1e1845139b2c7a5a843e1e8880697d99";
      name = "qtmultimedia-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtnetworkauth-everywhere-src-5.15.1.tar.xz";
      sha256 = "e5e37ae8f842e4bb66f1e719d8585ef71bc13c79545054fcd26072cd58e4d4c2";
      name = "qtnetworkauth-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtpurchasing-everywhere-src-5.15.1.tar.xz";
      sha256 = "be88908243a16fc0a1b22d656b7b651690b757329ea9fd2236998004fbd57f75";
      name = "qtpurchasing-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtquick3d-everywhere-src-5.15.1.tar.xz";
      sha256 = "a18ce5549f9d7a3c313385733eae7fe7b501d74a450c2515f887c671a9fa3457";
      name = "qtquick3d-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtquickcontrols-everywhere-src-5.15.1.tar.xz";
      sha256 = "0172f88779305aae57f3842538e91361ae9bc5ca2275ee5ce9d455309f0f2c7e";
      name = "qtquickcontrols-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtquickcontrols2-everywhere-src-5.15.1.tar.xz";
      sha256 = "e902b3baf9fe02a5bd675fc71118e282bb6a128c94f45be6f65d7d6db991f2af";
      name = "qtquickcontrols2-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtquicktimeline-everywhere-src-5.15.1.tar.xz";
      sha256 = "15665d489a6a29ff406a5fe2b4ac14ab102fb6e43864e115432be065da073cca";
      name = "qtquicktimeline-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtremoteobjects-everywhere-src-5.15.1.tar.xz";
      sha256 = "71b58fdac717645fa6f8b6ecb79b86841c540838877d100fabe2381175c4154e";
      name = "qtremoteobjects-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtscript = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtscript-everywhere-src-5.15.1.tar.xz";
      sha256 = "0a62152835363a9cc20558d0c2953ec03426324138578baa18fc2cc4d62b18ca";
      name = "qtscript-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtscxml = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtscxml-everywhere-src-5.15.1.tar.xz";
      sha256 = "2289f8c1b51ac368cc0ba8a6a987b44d2c97b43697b00e64582e43afedffcd2b";
      name = "qtscxml-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtsensors = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtsensors-everywhere-src-5.15.1.tar.xz";
      sha256 = "8096b9ffe737434f9564432048f622f6be795619da4e1ed362ce26dddb2cea00";
      name = "qtsensors-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtserialbus-everywhere-src-5.15.1.tar.xz";
      sha256 = "9ee220826032ae1f8e68d9ec7dddc10ddc4c2e0a771d34009ae307b07eeca751";
      name = "qtserialbus-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtserialport = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtserialport-everywhere-src-5.15.1.tar.xz";
      sha256 = "3605130148936ec3fd632bc13c70873d74ef9a8a0b28b17f3be917d848cfb8d9";
      name = "qtserialport-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtspeech = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtspeech-everywhere-src-5.15.1.tar.xz";
      sha256 = "7d2a5f7cf653d711de249ce4689959866d2381c625ced7ed4db7c8baaa140edc";
      name = "qtspeech-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtsvg = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtsvg-everywhere-src-5.15.1.tar.xz";
      sha256 = "308160223c0bd7492d56fb5d7b7f705bfb130947ac065bf39280ec6d7cbe4f6a";
      name = "qtsvg-everywhere-src-5.15.1.tar.xz";
    };
  };
  qttools = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qttools-everywhere-src-5.15.1.tar.xz";
      sha256 = "c98ee5f0f980bf68cbf0c94d62434816a92441733de50bd9adbe9b9055f03498";
      name = "qttools-everywhere-src-5.15.1.tar.xz";
    };
  };
  qttranslations = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qttranslations-everywhere-src-5.15.1.tar.xz";
      sha256 = "46e0c0e3a511fbcc803a4146204062e47f6ed43b34d98a3c27372a03b8746bd8";
      name = "qttranslations-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtvirtualkeyboard-everywhere-src-5.15.1.tar.xz";
      sha256 = "8cf62c4f0662f3f4b52b32f9d2cf1845a636d3df663869a98d47dfe748eb1c3d";
      name = "qtvirtualkeyboard-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwayland = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwayland-everywhere-src-5.15.1.tar.xz";
      sha256 = "e2ff47b874f283a952efd6a8aaf5e8cdc462b5216dda1051b60fc6e80ac657b6";
      name = "qtwayland-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwebchannel-everywhere-src-5.15.1.tar.xz";
      sha256 = "7f3ef8e626d932bbc121810661a62ece3955ab982340676a19001417e2faf9fc";
      name = "qtwebchannel-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwebengine-everywhere-src-5.15.1.tar.xz";
      sha256 = "f903e98fe3cd717161252710125fce011cf882ced96c24968b0c38811fbefdf2";
      name = "qtwebengine-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwebglplugin-everywhere-src-5.15.1.tar.xz";
      sha256 = "63c76f384252090694a8a2a8a18441d4fc4502d688cc4ac798a0d27b2221733c";
      name = "qtwebglplugin-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwebsockets-everywhere-src-5.15.1.tar.xz";
      sha256 = "5f30053a0a794676ce7d7521f6b789409cc449a7e90cab547d871fc07a61dd7e";
      name = "qtwebsockets-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwebview = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwebview-everywhere-src-5.15.1.tar.xz";
      sha256 = "426852a3f569da82aa84dfd7f06c6aeb06488a927b66342a612401b41392b260";
      name = "qtwebview-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtwinextras-everywhere-src-5.15.1.tar.xz";
      sha256 = "c378b112de1b54dbd39b07b7e181250b99ea2ec4d1d710909bb3384665528e8b";
      name = "qtwinextras-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtx11extras-everywhere-src-5.15.1.tar.xz";
      sha256 = "f7cd7c475a41840209808bf8b1de1c6587c3c74e5ae3b0969760b9ed35159e59";
      name = "qtx11extras-everywhere-src-5.15.1.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.15.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.1/submodules/qtxmlpatterns-everywhere-src-5.15.1.tar.xz";
      sha256 = "6859d440ce662f3679ce483ebb5a552b619a32517cb1a52a38f967b377857745";
      name = "qtxmlpatterns-everywhere-src-5.15.1.tar.xz";
    };
  };
}
