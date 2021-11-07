# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/6.2
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qt3d-everywhere-src-6.2.1.tar.xz";
      sha256 = "730c0e8e1a1a59c4acbeca68e206bab14ef770f5dacb94b84103a82243cfeeb3";
      name = "qt3d-everywhere-src-6.2.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qt5compat-everywhere-src-6.2.1.tar.xz";
      sha256 = "3865c031450a3c2616de1e20104ca9470ac5447adf51faa918f8b01a2c425de7";
      name = "qt5compat-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtactiveqt-everywhere-src-6.2.1.tar.xz";
      sha256 = "26f5e3638e171e9aa2c8c82267328bd1fa8a31bad154638bd9d41b2db51bedf1";
      name = "qtactiveqt-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtbase-everywhere-src-6.2.1.tar.xz";
      sha256 = "2c5f07b5c3ea27d3fc1a46686ea3fb6724f94dddf1fb007de3eb0bdb87429079";
      name = "qtbase-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtcharts-everywhere-src-6.2.1.tar.xz";
      sha256 = "f92ad16abd382a1488e6aafa129d88887a14300cb0f237fe37bca9173cf5a688";
      name = "qtcharts-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtconnectivity-everywhere-src-6.2.1.tar.xz";
      sha256 = "8dcc366b0f5f124b20bf25e1b207a5ae4b75e45c62d2cc1f4dce138075c2714e";
      name = "qtconnectivity-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtdatavis3d-everywhere-src-6.2.1.tar.xz";
      sha256 = "bfcf311df531498705786d0a689ae50a26169ce7db5da10e97ab579815bfb009";
      name = "qtdatavis3d-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtdeclarative-everywhere-src-6.2.1.tar.xz";
      sha256 = "5aeb841a5665f79672a302569754ea7d541c69102c551707e43489e797213c71";
      name = "qtdeclarative-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtdoc-everywhere-src-6.2.1.tar.xz";
      sha256 = "c30eb5742317dc52c5b93cbcc62c9a66af83df4e33177111d68e98211ee745e0";
      name = "qtdoc-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtimageformats-everywhere-src-6.2.1.tar.xz";
      sha256 = "df61dc1a517988bfa123117c78a7dbeda859cbb6d9cbd080ce60058277bca3df";
      name = "qtimageformats-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtlocation-everywhere-src-6.2.1.tar.xz";
      sha256 = "a99e92c762d45b17e14685cd8a3c1564a3da0ce1cfd1a68ffd5b3fd7c409dcad";
      name = "qtlocation-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtlottie-everywhere-src-6.2.1.tar.xz";
      sha256 = "6f896b47aa3c9a0ea3905a3d49b8737ff42a444c2deb54d80426da80b2fabfd3";
      name = "qtlottie-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtmultimedia-everywhere-src-6.2.1.tar.xz";
      sha256 = "07764ad31d4d4ef679c3ceb861e762d12690b4fa899b3ccec45e5353309a90d0";
      name = "qtmultimedia-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtnetworkauth-everywhere-src-6.2.1.tar.xz";
      sha256 = "8027f85095a9c56d8cada988527454f786a5f8dd4157206db4f21299016d1c9e";
      name = "qtnetworkauth-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtquick3d-everywhere-src-6.2.1.tar.xz";
      sha256 = "4022ce0e40a5d1c93a9593037a151cf7abe64c91a8b9882d9549f6a3c002a1b2";
      name = "qtquick3d-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtquicktimeline-everywhere-src-6.2.1.tar.xz";
      sha256 = "55f571ee2adcf7b12473b8df8b9e2e60d3778d8c9055c301d4c11d7c2327de63";
      name = "qtquicktimeline-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtremoteobjects-everywhere-src-6.2.1.tar.xz";
      sha256 = "76681b03bb63e1cafa38a1bfde23c194f232aaff4b010d5f58c065fdcc0b379f";
      name = "qtremoteobjects-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtscxml-everywhere-src-6.2.1.tar.xz";
      sha256 = "cff613f68af98f4bdc1e40df0b6515b69175e10e83c551a57ee5db4359505767";
      name = "qtscxml-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtsensors-everywhere-src-6.2.1.tar.xz";
      sha256 = "5f55c972c52848f5c828148fded1b30de32955f7ee04867568c559991214739a";
      name = "qtsensors-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtserialbus-everywhere-src-6.2.1.tar.xz";
      sha256 = "15e7a0a578dc9ed306ff2598edb9822081902ef1a4b52b20f1d2dd6461239f85";
      name = "qtserialbus-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtserialport-everywhere-src-6.2.1.tar.xz";
      sha256 = "ec77f4c9d6096588f3e735315f873976103479be453985b27f27fe8994e0776a";
      name = "qtserialport-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtshadertools-everywhere-src-6.2.1.tar.xz";
      sha256 = "2c8d38724181b31cd828a56e377775c2d461ee2ea0d6362ebec411c3b288067e";
      name = "qtshadertools-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtsvg-everywhere-src-6.2.1.tar.xz";
      sha256 = "86e27e005c2421052ca90e619c8d13f1bd19c6bf1a7b84dd4e0f7855fc884fd7";
      name = "qtsvg-everywhere-src-6.2.1.tar.xz";
    };
  };
  qttools = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qttools-everywhere-src-6.2.1.tar.xz";
      sha256 = "5a856d3d3d5fe6e15dc3f1af707a0ef1df2e687850403fc94af635edb9312bfb";
      name = "qttools-everywhere-src-6.2.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qttranslations-everywhere-src-6.2.1.tar.xz";
      sha256 = "3f680b520da585697fc725697a52c7d2074a6a728f6830366b491a6f8b9183c7";
      name = "qttranslations-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtvirtualkeyboard-everywhere-src-6.2.1.tar.xz";
      sha256 = "61baa6be64b41f3b1e526ed11896f818a50eb50d282906d4464eb8e0fa98f0fe";
      name = "qtvirtualkeyboard-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtwayland-everywhere-src-6.2.1.tar.xz";
      sha256 = "051e6bd0a6fed988436fd86ad5146a556151f3a51f8bd5c4a31c99845a54efd7";
      name = "qtwayland-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtwebchannel-everywhere-src-6.2.1.tar.xz";
      sha256 = "035ba2e9a0e9de0baddd40f9d50014e6eb5f0b4ec741e9aec1b434e7c9e4e9c9";
      name = "qtwebchannel-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtwebengine-everywhere-src-6.2.1.tar.xz";
      sha256 = "1f933cffb8671c1e71b6b2a4924cb6b3f9878388ae6298ac8d31a76c1ecffbb7";
      name = "qtwebengine-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtwebsockets-everywhere-src-6.2.1.tar.xz";
      sha256 = "23344e21e96a839697abed7bf7931a8c08a752f08bf25edf240748501aba3816";
      name = "qtwebsockets-everywhere-src-6.2.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.2.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.1/submodules/qtwebview-everywhere-src-6.2.1.tar.xz";
      sha256 = "9aedbbbcf74ce60f250ae843b625e31f90f84613f6d6e60bcc5d98f2edda4e6a";
      name = "qtwebview-everywhere-src-6.2.1.tar.xz";
    };
  };
}
