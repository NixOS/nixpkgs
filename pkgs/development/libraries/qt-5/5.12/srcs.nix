# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qt3d-everywhere-src-5.12.5.tar.xz";
      sha256 = "2a35b144768c7ad8a9265d16a04f038d9bc51016bd2c4b2b516e374f81ff29c4";
      name = "qt3d-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtactiveqt-everywhere-src-5.12.5.tar.xz";
      sha256 = "d673a1269dd900c78dbfe88eb16e086e36d236571722712a64401cdec7b73a40";
      name = "qtactiveqt-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtandroidextras-everywhere-src-5.12.5.tar.xz";
      sha256 = "f115ccef1e808da7c5d0348f3e245952a2973966f34d18b935f9e3eb16062eab";
      name = "qtandroidextras-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtbase-everywhere-src-5.12.5.tar.xz";
      sha256 = "fc8abffbbda9da3e593d8d62b56bc17dbaab13ff71b72915ddda11dabde4d625";
      name = "qtbase-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtcanvas3d-everywhere-src-5.12.5.tar.xz";
      sha256 = "1553e06ce3cc5afb36aed3698b85c00e734eac07f7f41895426bebd84216d80c";
      name = "qtcanvas3d-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtcharts-everywhere-src-5.12.5.tar.xz";
      sha256 = "4c7c30a916ba0100a1635b89f48bc5a8af4cdedac79c3fc18456af54dc0a6608";
      name = "qtcharts-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtconnectivity-everywhere-src-5.12.5.tar.xz";
      sha256 = "bdf62c72d689f47c4d17ecdde934d9f85a1164091e58fce02873de259e8de88b";
      name = "qtconnectivity-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtdatavis3d-everywhere-src-5.12.5.tar.xz";
      sha256 = "1de165bf5330c7fb18c6fbb8c0e5cda47fa19c2eaba657b3792fd75e653444f3";
      name = "qtdatavis3d-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtdeclarative-everywhere-src-5.12.5.tar.xz";
      sha256 = "22c5323d4b01259e6e352eef1b54129d6dfee00a406f0312905fa7db322b9190";
      name = "qtdeclarative-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtdoc-everywhere-src-5.12.5.tar.xz";
      sha256 = "f1de30227b8854c284e9c23e9c0c44d9fe768880aef826b0f880a44dd7c7538d";
      name = "qtdoc-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtgamepad-everywhere-src-5.12.5.tar.xz";
      sha256 = "de88f01d47f7cc5d54a1af783c5fae9f2b0101948ff33b8290f71b2657aded33";
      name = "qtgamepad-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtgraphicaleffects-everywhere-src-5.12.5.tar.xz";
      sha256 = "bdbddba7e0e0d041809a98d97c07da8be8936ec48537335cbaea9b0049c646ad";
      name = "qtgraphicaleffects-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtimageformats-everywhere-src-5.12.5.tar.xz";
      sha256 = "9f19394830542fb9e6bde6806b6216b7207f96bff674b91e8e8a8f89699e1f0a";
      name = "qtimageformats-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtlocation-everywhere-src-5.12.5.tar.xz";
      sha256 = "12c8b59755abc4ca56e135e8ae3db7c6ba1bd95c779060f10a01393ae1040122";
      name = "qtlocation-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtmacextras-everywhere-src-5.12.5.tar.xz";
      sha256 = "984c3c95834aaa6fd85234ab1987a79662911c510e419611ce88fb4756313194";
      name = "qtmacextras-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtmultimedia-everywhere-src-5.12.5.tar.xz";
      sha256 = "d5a0a4fddc5ef14d641160a1fc0011b190ff8d9f19009498d586516b8ee3479c";
      name = "qtmultimedia-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtnetworkauth-everywhere-src-5.12.5.tar.xz";
      sha256 = "0933475a2d30550c70ce4026c72678cbfdac73211593c78d442e038ef531a9f1";
      name = "qtnetworkauth-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtpurchasing-everywhere-src-5.12.5.tar.xz";
      sha256 = "7bcebc4985d387f3fa4ffcc19eada1f4f0f000ed0fd3e1d1dc37eb1db0be615b";
      name = "qtpurchasing-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtquickcontrols-everywhere-src-5.12.5.tar.xz";
      sha256 = "46deaefbdac3daa576c748e807956f5f82b2318923b1a36e434a3ff32d1d2559";
      name = "qtquickcontrols-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtquickcontrols2-everywhere-src-5.12.5.tar.xz";
      sha256 = "d744bdc492486db6cb521b1d4891e2358719399825ca1cf2a50968a80f6acb8f";
      name = "qtquickcontrols2-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtremoteobjects-everywhere-src-5.12.5.tar.xz";
      sha256 = "acf131af93dd1fefbf30c7e03e29b8a1da3180e00c49f95c14a1cb6158cfeacd";
      name = "qtremoteobjects-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtscript-everywhere-src-5.12.5.tar.xz";
      sha256 = "0083734ae827840334b774decb15de37f1b4ea5c88e442e2f485c530f24f1df4";
      name = "qtscript-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtscxml-everywhere-src-5.12.5.tar.xz";
      sha256 = "6f1ec74100cdb2e7dfc3535e09d356fc53ba42e61b32fc3b93d5a7efed49960c";
      name = "qtscxml-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtsensors-everywhere-src-5.12.5.tar.xz";
      sha256 = "e3a86a706f475bb23fc874de56026482de223ebd24f8cb4e94a28d1985ca0b85";
      name = "qtsensors-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtserialbus-everywhere-src-5.12.5.tar.xz";
      sha256 = "8474ae61a703c56e327ae0755c27643f2eafe0d915e8c6afb21728548dc02c22";
      name = "qtserialbus-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtserialport-everywhere-src-5.12.5.tar.xz";
      sha256 = "f8ef0321a59ecfe2c72adc2ee220e0047403439a3c7b9efb719b1476af1fb862";
      name = "qtserialport-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtspeech-everywhere-src-5.12.5.tar.xz";
      sha256 = "f94c0cd7236d1a20d97d314d2c17c45c967cd7f24b869c43f5f46253f436f25b";
      name = "qtspeech-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtsvg-everywhere-src-5.12.5.tar.xz";
      sha256 = "75a791cf749f671d7ea9090b403ca513f745795018db512e7eecbf418b679840";
      name = "qtsvg-everywhere-src-5.12.5.tar.xz";
    };
  };
  qttools = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qttools-everywhere-src-5.12.5.tar.xz";
      sha256 = "28e095047b4985437dd66120cbcb49ac091bf4f12576ecad7ebc781b7dd44025";
      name = "qttools-everywhere-src-5.12.5.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qttranslations-everywhere-src-5.12.5.tar.xz";
      sha256 = "72eb6317190fdcc3f8de37996adc646ab8772988766bacaab60a5bcc7d6a3f2a";
      name = "qttranslations-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtvirtualkeyboard-everywhere-src-5.12.5.tar.xz";
      sha256 = "786d745b34b1f145073488d492325e98bcde81b07ab984032ea5eb2fb52e6e5e";
      name = "qtvirtualkeyboard-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwayland-everywhere-src-5.12.5.tar.xz";
      sha256 = "29fd31267149451f93faa15f031e0a14506e704086033f70d51479522c6f3846";
      name = "qtwayland-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwebchannel-everywhere-src-5.12.5.tar.xz";
      sha256 = "9f1d1ac20722ee053ecf071d4ec0070a45a765cb67b6e31add61004fb4b3c5e8";
      name = "qtwebchannel-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwebengine-everywhere-src-5.12.5.tar.xz";
      sha256 = "31881130e69eb8336e9480f9f33cd5a93e86de8d7323c0ae1893e1a72ce70743";
      name = "qtwebengine-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwebglplugin-everywhere-src-5.12.5.tar.xz";
      sha256 = "aac3b2b2e5b6f26dd7abba6eab616777fecbb4d06de05ddab68c1296652bc4f7";
      name = "qtwebglplugin-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwebsockets-everywhere-src-5.12.5.tar.xz";
      sha256 = "5d58e697c49c0ea19a8299deba84b5360dca8c336a1636d38de0351757293262";
      name = "qtwebsockets-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwebview-everywhere-src-5.12.5.tar.xz";
      sha256 = "a6d4d8c335cd6838f4638874fcd67655e80db569ed567a774a84f6bf7d332f26";
      name = "qtwebview-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtwinextras-everywhere-src-5.12.5.tar.xz";
      sha256 = "7ee2fc73bc95c5e36e8ed2d02fc89822d56c406c540fbfa52bb0e3929ff2f93d";
      name = "qtwinextras-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtx11extras-everywhere-src-5.12.5.tar.xz";
      sha256 = "89425af3e48b040878c6a64ace58c17a83b87c9330e6366b09a41d6797062a68";
      name = "qtx11extras-everywhere-src-5.12.5.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.5";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.5/submodules/qtxmlpatterns-everywhere-src-5.12.5.tar.xz";
      sha256 = "b905d9107f87798ef0f142942fc45c0f63fc113522ab041e791d3cb744a8babd";
      name = "qtxmlpatterns-everywhere-src-5.12.5.tar.xz";
    };
  };
}
