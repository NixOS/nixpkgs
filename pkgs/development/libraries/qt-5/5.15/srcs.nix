# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.15
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qt3d-everywhere-src-5.15.0.tar.xz";
      sha256 = "61856f0c453b79e98b7a1e65ea8f59976fa78230ffa8dec959b5f4b45383dffd";
      name = "qt3d-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtactiveqt-everywhere-src-5.15.0.tar.xz";
      sha256 = "1b455eacfb9ef49912d7a79040ea409a6ab88dfa192d313e6b5e02a79d741b51";
      name = "qtactiveqt-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtandroidextras-everywhere-src-5.15.0.tar.xz";
      sha256 = "c9019185221e94e37e250c84acaebfb7b2f5342e8ad60cdcff052ac2b85ec671";
      name = "qtandroidextras-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtbase = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtbase-everywhere-src-5.15.0.tar.xz";
      sha256 = "9e7af10aece15fa9500369efde69cb220eee8ec3a6818afe01ce1e7d484824c5";
      name = "qtbase-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtcharts = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtcharts-everywhere-src-5.15.0.tar.xz";
      sha256 = "44a24fc16abcaf9ae97ecf3215f6f3b44ebdb3b73bcb4ed3549a51519e4883a7";
      name = "qtcharts-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtconnectivity-everywhere-src-5.15.0.tar.xz";
      sha256 = "f911fb8f8bf3a9958785d0378d25ced8989047938b7138d619854a94fa0b27dd";
      name = "qtconnectivity-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtdatavis3d-everywhere-src-5.15.0.tar.xz";
      sha256 = "8f07747f371f7c515c667240a795105c89aa83c08d88ee92fa1ef7efccea10a3";
      name = "qtdatavis3d-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtdeclarative-everywhere-src-5.15.0.tar.xz";
      sha256 = "9c3c93fb7d340b2f7d738d12408c047318c78973cb45bfc5ff6b3a57e1fef699";
      name = "qtdeclarative-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtdoc = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtdoc-everywhere-src-5.15.0.tar.xz";
      sha256 = "07ca8db98c317f25cc9a041c48a6824baf63893bf5b535d6f8d266dea8c7659f";
      name = "qtdoc-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtgamepad-everywhere-src-5.15.0.tar.xz";
      sha256 = "dda54d9f90897944bed5e6af48a904a677fd97eb6f57ab08a2b232c431caf31a";
      name = "qtgamepad-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtgraphicaleffects-everywhere-src-5.15.0.tar.xz";
      sha256 = "0d2ea4bc73b9df13a4b739dcbc1e3c7b298c7e682f7f9252b232e3bde7b63eda";
      name = "qtgraphicaleffects-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtimageformats-everywhere-src-5.15.0.tar.xz";
      sha256 = "83f32101b1a898fcb8ed6f11a657d1125484ac0c2223014b61849d9010efebc8";
      name = "qtimageformats-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtlocation = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtlocation-everywhere-src-5.15.0.tar.xz";
      sha256 = "c68b0778a521e5522641c41b1778999dd408ebfda1e0de166a83743268be5f3f";
      name = "qtlocation-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtlottie = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtlottie-everywhere-src-5.15.0.tar.xz";
      sha256 = "2053f474dcd7184fdcae2507f47af6527f6ca25b4424483f9265853c3626c833";
      name = "qtlottie-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtmacextras-everywhere-src-5.15.0.tar.xz";
      sha256 = "95a8c35b30373224cdd6d1ca0bdda1a314b20e91551a4824e8ca7e50ce8ff439";
      name = "qtmacextras-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtmultimedia-everywhere-src-5.15.0.tar.xz";
      sha256 = "0708d867697f392dd3600c5c1c88f5c61b772a5250a4d059dca67b844af0fbd7";
      name = "qtmultimedia-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtnetworkauth-everywhere-src-5.15.0.tar.xz";
      sha256 = "96c6107f6e85662a05f114c5b9bd3503a3100bd940e1494c73a99e77f9e7cf85";
      name = "qtnetworkauth-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtpurchasing-everywhere-src-5.15.0.tar.xz";
      sha256 = "2127f180c4889055d88e2b402b62be80a5a213a0e48d2056cc9a01d9913b3a16";
      name = "qtpurchasing-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtquick3d-everywhere-src-5.15.0.tar.xz";
      sha256 = "6d3b91b653ba5e33fd5b37cd785ded6cf1dd83d35250c3addb77eb35f90e52cb";
      name = "qtquick3d-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtquickcontrols-everywhere-src-5.15.0.tar.xz";
      sha256 = "7072cf4cd27e9f18b36b1c48dec7c79608cf87ba847d3fc3de133f220ec1acee";
      name = "qtquickcontrols-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtquickcontrols2-everywhere-src-5.15.0.tar.xz";
      sha256 = "839abda9b58cd8656b2e5f46afbb484e63df466481ace43318c4c2022684648f";
      name = "qtquickcontrols2-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtquicktimeline-everywhere-src-5.15.0.tar.xz";
      sha256 = "16ffeb733ba15815121fca5705ed5220ce0a0eb2ec0431ad0d55da9426a03c00";
      name = "qtquicktimeline-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtremoteobjects-everywhere-src-5.15.0.tar.xz";
      sha256 = "86fcfdce77f13c7babdec4dc1d0c4b7b6b02e40120a4250dc59e911c53c08abf";
      name = "qtremoteobjects-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtscript = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtscript-everywhere-src-5.15.0.tar.xz";
      sha256 = "02dc21b309621876a89671be27cea86a58e74a96aa28da65fe1b37a3aad29373";
      name = "qtscript-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtscxml = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtscxml-everywhere-src-5.15.0.tar.xz";
      sha256 = "9c3a72bf5ebd07553b0049cc1943f04cff93b7e53bde8c81d652422dbf12ff72";
      name = "qtscxml-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtsensors = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtsensors-everywhere-src-5.15.0.tar.xz";
      sha256 = "12b17ed6cbe6c49c8ab71958bc5d8ad1c42bf20e2fa72613ede11001e98144da";
      name = "qtsensors-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtserialbus-everywhere-src-5.15.0.tar.xz";
      sha256 = "cee067c84d025e221b83d109b58ea16c4d2dc0af0aea45cc6724acd33a1b7379";
      name = "qtserialbus-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtserialport = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtserialport-everywhere-src-5.15.0.tar.xz";
      sha256 = "ba19369069a707dffddca8d9c477bb2bb4aa26630dfee6792254c4bf9bd57a67";
      name = "qtserialport-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtspeech = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtspeech-everywhere-src-5.15.0.tar.xz";
      sha256 = "7219a878c14a24d0ca18d52df1717361b13aee96ac9790baf9ad2b383492dd61";
      name = "qtspeech-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtsvg = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtsvg-everywhere-src-5.15.0.tar.xz";
      sha256 = "ee4d287e2e205ca8c08921b9cbe0fc58bf46be080b5359ad4d7fbdee44aeee0d";
      name = "qtsvg-everywhere-src-5.15.0.tar.xz";
    };
  };
  qttools = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qttools-everywhere-src-5.15.0.tar.xz";
      sha256 = "ddbcb49aab3a2e3672582c6e2e7bec0058feff790f67472343c79e2895e0e437";
      name = "qttools-everywhere-src-5.15.0.tar.xz";
    };
  };
  qttranslations = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qttranslations-everywhere-src-5.15.0.tar.xz";
      sha256 = "45c43268d9df50784d4d8ca345fce9288a1055fd074ac0ef508097f7aeba22fe";
      name = "qttranslations-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtvirtualkeyboard-everywhere-src-5.15.0.tar.xz";
      sha256 = "f22f9204ab65578d9c8aa832a8a39108f826e00a7d391c7884ff490c587f34be";
      name = "qtvirtualkeyboard-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwayland = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwayland-everywhere-src-5.15.0.tar.xz";
      sha256 = "084133e10bfbd32a28125639660c59975f23457bba6a79b30a25802cec76a9fb";
      name = "qtwayland-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwebchannel-everywhere-src-5.15.0.tar.xz";
      sha256 = "ea80510b363e6f92ce99932f06d176e43459c4a5159fe97b5ef96fcfbab5ed4f";
      name = "qtwebchannel-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwebengine-everywhere-src-5.15.0.tar.xz";
      sha256 = "c38e2fda7ed1b7d5a90f26abf231ec0715d78a5bc39a94673d8e39d75f04c5df";
      name = "qtwebengine-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwebglplugin-everywhere-src-5.15.0.tar.xz";
      sha256 = "f7b81f25ddf7b3a0046daa7224bc1e18c8b754b00b1a33775f30f827a5cdca15";
      name = "qtwebglplugin-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwebsockets-everywhere-src-5.15.0.tar.xz";
      sha256 = "87c2f6542778f9b65b3f208740c1d0db643fd0bede21404b9abb265355da5092";
      name = "qtwebsockets-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwebview = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwebview-everywhere-src-5.15.0.tar.xz";
      sha256 = "b87ea205ce79c6b438ebe596e91fa80ba11f6aac7e89ffbf52b337d0fc8d6660";
      name = "qtwebview-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtwinextras-everywhere-src-5.15.0.tar.xz";
      sha256 = "d77f2cb2ce83bdbfd0a970bc8d7d11c96b2df16befc257d6594f79dfd92abff0";
      name = "qtwinextras-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtx11extras-everywhere-src-5.15.0.tar.xz";
      sha256 = "c72b6c188284facddcf82835af048240e721dc8d6d9e8a7bd71d76fd876881a1";
      name = "qtx11extras-everywhere-src-5.15.0.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.0/submodules/qtxmlpatterns-everywhere-src-5.15.0.tar.xz";
      sha256 = "2752cf2aa25ebfda89c3736457e27b3d0c7c7ed290dcfd52c209f9f905998507";
      name = "qtxmlpatterns-everywhere-src-5.15.0.tar.xz";
    };
  };
}
