# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/6.2
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qt3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "304352ae74fc8e7fe50a822413d69094efb25f15a2323e083a2a53dc5a43a6c6";
      name = "qt3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qt5compat-everywhere-src-6.2.0.tar.xz";
      sha256 = "c2e2f058ecee36a96c1b15937badeda9b7b03eb5278fa01af4ff386c4f1854fb";
      name = "qt5compat-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtactiveqt-everywhere-src-6.2.0.tar.xz";
      sha256 = "ed991638e27e2e8eac487c2002845827097d1e66397100eea2061d8ad790ded2";
      name = "qtactiveqt-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtbase-everywhere-src-6.2.0.tar.xz";
      sha256 = "fdfff0716d093bcb6bcd53746ce1d3c9701a6bf3326d47813866d43949b47769";
      name = "qtbase-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtcharts-everywhere-src-6.2.0.tar.xz";
      sha256 = "9114d4e05e63f5b9d5f07d53d72bf2fbfb22ffae283cc98d3371d73f04b6f4fc";
      name = "qtcharts-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtconnectivity-everywhere-src-6.2.0.tar.xz";
      sha256 = "4c689100bb43f78a7e30380296376b7f4dff356d9a02b0bba97362d6b497649c";
      name = "qtconnectivity-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdatavis3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "e089295b8e33ded025ac27fff0b7e43ee91b2df0b8887431ab2236538e07db9e";
      name = "qtdatavis3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdeclarative-everywhere-src-6.2.0.tar.xz";
      sha256 = "46737feceb9e54d63ad0c87a08d33f08ca58f4b8920ccefad8f1ebd64f0d1270";
      name = "qtdeclarative-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtdoc-everywhere-src-6.2.0.tar.xz";
      sha256 = "cf2e3757e084fa542fb5059b7227e222852f82a9cda15024e428091400bba674";
      name = "qtdoc-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtimageformats-everywhere-src-6.2.0.tar.xz";
      sha256 = "fdaa35536c3d0f8f5f313d0d52dedfbf6d8fcd81a82d6a56f473253f135072ad";
      name = "qtimageformats-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtlocation-everywhere-src-6.2.0.tar.xz";
      sha256 = "c627f85afbffe18b91e9081e9a4867b79c81a0ea24a683a2d5847c55097b5426";
      name = "qtlocation-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtlottie-everywhere-src-6.2.0.tar.xz";
      sha256 = "aa129261d409b5d935221acd6e38f56d68eac5e467a1990c96c654e81a2522ff";
      name = "qtlottie-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtmultimedia-everywhere-src-6.2.0.tar.xz";
      sha256 = "f12b96e6da2ebfe84105c0cb6e96fbc6bda012de8998ec5c96b58c85dcb40b4f";
      name = "qtmultimedia-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtnetworkauth-everywhere-src-6.2.0.tar.xz";
      sha256 = "e71504c8d6ae4cf4d573f1d91ff756f90f441e22b0af12eae2424f7e0c01d450";
      name = "qtnetworkauth-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquick3d-everywhere-src-6.2.0.tar.xz";
      sha256 = "e8f8163237468e158ace7737d60a0a722209ffda444c57c786fc53db1af851e1";
      name = "qtquick3d-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtquicktimeline-everywhere-src-6.2.0.tar.xz";
      sha256 = "67d644ad12df94e937bac3a1cb8a81a96213ec0102759a86c59ba7834ac90c8c";
      name = "qtquicktimeline-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtremoteobjects-everywhere-src-6.2.0.tar.xz";
      sha256 = "69b2ee333569bab026eaf16e4a552f912c0dc5afbe01e1609ddbb0e78b4593ca";
      name = "qtremoteobjects-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtscxml-everywhere-src-6.2.0.tar.xz";
      sha256 = "90d4af011a17f04a003cbd453c7e0720787e6cdacb8dfce7167179c2cd7dc839";
      name = "qtscxml-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtsensors-everywhere-src-6.2.0.tar.xz";
      sha256 = "1a3ea1253408c91046ae1e775e28b1fe7acfbb7ee18952605379d35bb1e93678";
      name = "qtsensors-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtserialbus-everywhere-src-6.2.0.tar.xz";
      sha256 = "b8cfe2a5b49f8e06c76072021015c107fb35a678d1d28beaba9e629be18aac41";
      name = "qtserialbus-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtserialport-everywhere-src-6.2.0.tar.xz";
      sha256 = "3fb3c0c37602e6fee8c5e386b61d14f4d7a820cf9e053c6952ad6e860ce05248";
      name = "qtserialport-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtshadertools-everywhere-src-6.2.0.tar.xz";
      sha256 = "5f66d43610a3a6739fc360d836a2c045135107c0ecd40eb3ed18ce5f3dd79c42";
      name = "qtshadertools-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtsvg-everywhere-src-6.2.0.tar.xz";
      sha256 = "af9eabefbb0dcb772f18fae4d2c39bcc23579a5dfff569c35ea7e497591db3d4";
      name = "qtsvg-everywhere-src-6.2.0.tar.xz";
    };
  };
  qttools = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qttools-everywhere-src-6.2.0.tar.xz";
      sha256 = "a903d005f8ab39545aed88a13b04f13ddbbe073da7007203a91fb8b42b890057";
      name = "qttools-everywhere-src-6.2.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qttranslations-everywhere-src-6.2.0.tar.xz";
      sha256 = "5b4ecb1ee35363444f03b1eb10637d79af1d19be5a5cc53657dc0925a78b2240";
      name = "qttranslations-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtvirtualkeyboard-everywhere-src-6.2.0.tar.xz";
      sha256 = "1055e7fe1dfaecbfd4b69f40ec1135fda1980e6e21adbe757a8a4affbfb9bcee";
      name = "qtvirtualkeyboard-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwayland-everywhere-src-6.2.0.tar.xz";
      sha256 = "d6787fce74bde1a3386bcbe43c078c712471bab09f1946c40fc2327232d27d4c";
      name = "qtwayland-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebchannel-everywhere-src-6.2.0.tar.xz";
      sha256 = "518391ed74b087da3c15058c9c17760204425599ef3ffe61b1b73edc2028c171";
      name = "qtwebchannel-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebengine-everywhere-src-6.2.0.tar.xz";
      sha256 = "c6e530a61bea2e7fbb50308a2b4e7fdb4f7c7b61a28797973270acffc020809d";
      name = "qtwebengine-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebsockets-everywhere-src-6.2.0.tar.xz";
      sha256 = "4278a1aa961f4b9c752db38ee3f5319b56f1033d0e6982eabbba6eaffb14c59f";
      name = "qtwebsockets-everywhere-src-6.2.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.0/submodules/qtwebview-everywhere-src-6.2.0.tar.xz";
      sha256 = "75fbc1e372d4034361c16571798ac94e8c3ccfbdfbb06dca40b7c2230235708e";
      name = "qtwebview-everywhere-src-6.2.0.tar.xz";
    };
  };
}
