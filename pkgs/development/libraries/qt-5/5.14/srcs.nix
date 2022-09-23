# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.14
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qt3d-everywhere-src-5.14.2.tar.xz";
      sha256 = "9da82f1cc4b7d416d31ec96224c59d221473a48f6e579eef978f7d2e3932c674";
      name = "qt3d-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtactiveqt-everywhere-src-5.14.2.tar.xz";
      sha256 = "b53517d5d128719773a2941ba52da10acd7aa3149948862bc08c98f5b64152a9";
      name = "qtactiveqt-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtandroidextras-everywhere-src-5.14.2.tar.xz";
      sha256 = "4a8fd92b5c49a663cf0bd492804eaf1574d11137e2cbdd41d6bf5fad0c3c4d76";
      name = "qtandroidextras-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtbase = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtbase-everywhere-src-5.14.2.tar.xz";
      sha256 = "48b9e79220941665a9dd827548c6428f7aa3052ccba8f4f7e039a94aa1d2b28a";
      name = "qtbase-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtcharts = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtcharts-everywhere-src-5.14.2.tar.xz";
      sha256 = "adb25203ea748d886cc3d8993c20def702115eccea311594592058134ba83bb7";
      name = "qtcharts-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtconnectivity-everywhere-src-5.14.2.tar.xz";
      sha256 = "abe67b3e3a775e2a2e27c62a5391f37007ffbe72bce58b96116995616cfcbc28";
      name = "qtconnectivity-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtdatavis3d-everywhere-src-5.14.2.tar.xz";
      sha256 = "723c03db2d2805b1be4ca534ac7bc867a1a21894d33a7e9261a382f3fa9d0e20";
      name = "qtdatavis3d-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtdeclarative-everywhere-src-5.14.2.tar.xz";
      sha256 = "a3c4617adc9760347c93d2eb6c25d22f620cd22f44afa0494eb499a805831650";
      name = "qtdeclarative-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtdoc = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtdoc-everywhere-src-5.14.2.tar.xz";
      sha256 = "5a55cdb55af35eb222d06179567851c175f24a3732f7dee5be073df4a893172b";
      name = "qtdoc-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtgamepad-everywhere-src-5.14.2.tar.xz";
      sha256 = "f77daadb4755cf760e11812264259fb103396fd1b06df1e06b5df162081c8d03";
      name = "qtgamepad-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtgraphicaleffects-everywhere-src-5.14.2.tar.xz";
      sha256 = "487a7f858244a08264363733055a8cf8b00e77c658c5608cc462817d15e4b50f";
      name = "qtgraphicaleffects-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtimageformats-everywhere-src-5.14.2.tar.xz";
      sha256 = "733eca0165c15e046b106039c989dac7f6bc2ecf215396d965ed065369264f8c";
      name = "qtimageformats-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtlocation = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtlocation-everywhere-src-5.14.2.tar.xz";
      sha256 = "c37708bc396f6dac397b49a6a268d5edb39e1c8296ca2337ce9e80bde04775cc";
      name = "qtlocation-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtlottie = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtlottie-everywhere-src-5.14.2.tar.xz";
      sha256 = "55d1392dc92cbec11263084360075dc5fc3fdc25c1969adfbdec84299b285978";
      name = "qtlottie-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtmacextras-everywhere-src-5.14.2.tar.xz";
      sha256 = "d12587b46c84a7822194fc3ccf46f7c18ff3b31566d3dde4f5fe772f1d8776e5";
      name = "qtmacextras-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtmultimedia-everywhere-src-5.14.2.tar.xz";
      sha256 = "7acd8ede6835314206e407b35b668f0add67544577fb51fe67afb03137fb9fe9";
      name = "qtmultimedia-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtnetworkauth-everywhere-src-5.14.2.tar.xz";
      sha256 = "4f00513dd18598487d02187b80b54c669662cf8a8f2573858c7f9282d7b9265e";
      name = "qtnetworkauth-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtpurchasing-everywhere-src-5.14.2.tar.xz";
      sha256 = "69b087001e8fcec5bb49ca333d5f44e6b7eb09f76421dc792fc9cd76dee9e851";
      name = "qtpurchasing-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtquick3d-everywhere-src-5.14.2.tar.xz";
      sha256 = "0640696d501f2b0bf57f64e98f30bfa3e1cc19c11c0e05e43d4fdb0d20488b2e";
      name = "qtquick3d-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtquickcontrols-everywhere-src-5.14.2.tar.xz";
      sha256 = "d55def1dd4ee1250bd6a4e76849f4e362368b6411c2216d5f669c761216d4461";
      name = "qtquickcontrols-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtquickcontrols2-everywhere-src-5.14.2.tar.xz";
      sha256 = "faf7d349d8f4a8db36cd3c62a5724bcf689300f2fdb7dc1ea034392aab981560";
      name = "qtquickcontrols2-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtquicktimeline-everywhere-src-5.14.2.tar.xz";
      sha256 = "83a45d0998cbc77f8094854a477ab1ac0838ae7fd822563d995df40149893a9e";
      name = "qtquicktimeline-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtremoteobjects-everywhere-src-5.14.2.tar.xz";
      sha256 = "a6a601c4f4aab6fe41a462dae57033819f697e3317240a382cee45c08be614d6";
      name = "qtremoteobjects-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtscript = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtscript-everywhere-src-5.14.2.tar.xz";
      sha256 = "e9fd487ccb3cbf00e86b0b803aa79e9f6bbe7a337b8e97d069e040c3e0789bfe";
      name = "qtscript-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtscxml = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtscxml-everywhere-src-5.14.2.tar.xz";
      sha256 = "030cea352a56074f577200f967ef37c959b2767127de61f766f59b0d99763790";
      name = "qtscxml-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtsensors = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtsensors-everywhere-src-5.14.2.tar.xz";
      sha256 = "bccfca6910b0383d8f65823496ff5011abed2fa8fd446b4b27333d0fd7bb8c61";
      name = "qtsensors-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtserialbus-everywhere-src-5.14.2.tar.xz";
      sha256 = "0b7762175a649a40c4dd619c5de61d772235dc86099343278e2c3229d0836a91";
      name = "qtserialbus-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtserialport = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtserialport-everywhere-src-5.14.2.tar.xz";
      sha256 = "a6d977dd723ad4d3368b5163691405b8852f809974a96ec54103494e834aea21";
      name = "qtserialport-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtspeech = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtspeech-everywhere-src-5.14.2.tar.xz";
      sha256 = "5e9e8ea62f0207ba894df1e136df0af9fc5443c7817d28c39f0ea2bbae9ec6da";
      name = "qtspeech-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtsvg = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtsvg-everywhere-src-5.14.2.tar.xz";
      sha256 = "c7d7faa01a3e7a6e4d38fafcec5529a488258218749779e6fa0e09a21173b5a1";
      name = "qtsvg-everywhere-src-5.14.2.tar.xz";
    };
  };
  qttools = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qttools-everywhere-src-5.14.2.tar.xz";
      sha256 = "5bb0cf7832b88eb6bc9d4289f98307eb14b16a453ad6cf42cca13c4fe1a053c5";
      name = "qttools-everywhere-src-5.14.2.tar.xz";
    };
  };
  qttranslations = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qttranslations-everywhere-src-5.14.2.tar.xz";
      sha256 = "2088ebee9f5dd0336c9fd11436899a95b7ce0141ce072290de1e8f315d82d1a6";
      name = "qttranslations-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtvirtualkeyboard-everywhere-src-5.14.2.tar.xz";
      sha256 = "364f3338563e617e7c964a37170b415b546c5f82965e781271f9dada3e3868d7";
      name = "qtvirtualkeyboard-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwayland = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwayland-everywhere-src-5.14.2.tar.xz";
      sha256 = "d31633ca718fb407cf70870613d45d0ed80aa04c058586ac3036bae1aff7832a";
      name = "qtwayland-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwebchannel-everywhere-src-5.14.2.tar.xz";
      sha256 = "7d1dc8441523638c3d455c7d408ec65aebc073acab80e24063865f929231f874";
      name = "qtwebchannel-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwebengine-everywhere-src-5.14.2.tar.xz";
      sha256 = "e169d6a75d8c397e04f843bc1b9585950fb9a001255cd18d6293f66fa8a6c947";
      name = "qtwebengine-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwebglplugin-everywhere-src-5.14.2.tar.xz";
      sha256 = "eb4118910b65d03d8448658ac1646e860d337e59b82d6575beda21824e313417";
      name = "qtwebglplugin-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwebsockets-everywhere-src-5.14.2.tar.xz";
      sha256 = "f06e62b18313fe1b40a35566e79645de4a8e7ac9f7717d1d98a06c5b49afca84";
      name = "qtwebsockets-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwebview = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwebview-everywhere-src-5.14.2.tar.xz";
      sha256 = "c61f9213ee84fd7408898c0194468208ffb51af9d257e87e6b53daf24f65ff4b";
      name = "qtwebview-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtwinextras-everywhere-src-5.14.2.tar.xz";
      sha256 = "980f1bc31b37c8597c0bac55f69ecf00d1677218ce82f7bc3933236cb6d907f2";
      name = "qtwinextras-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtx11extras-everywhere-src-5.14.2.tar.xz";
      sha256 = "be9a84a03a2ee81771215264e5dff7a996d04be6192b8cdaa1d41e319a81545a";
      name = "qtx11extras-everywhere-src-5.14.2.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.14.2";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.14/5.14.2/submodules/qtxmlpatterns-everywhere-src-5.14.2.tar.xz";
      sha256 = "219a876665345e3801baff71f31f30f5495c1cb9ab23fbbd27602632c80fcfb7";
      name = "qtxmlpatterns-everywhere-src-5.14.2.tar.xz";
    };
  };
}
