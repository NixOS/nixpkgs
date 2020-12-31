# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.12
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qt3d-everywhere-src-5.12.9.tar.xz";
      sha256 = "6fcde8c99bc5d09a5d2de99cab10c6f662d7db48139e6d5a3904fa0c580070ad";
      name = "qt3d-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtactiveqt-everywhere-src-5.12.9.tar.xz";
      sha256 = "e9df2dacfa4f93b42753066d14d3c504a30b259c177b366e32e6119f714f6527";
      name = "qtactiveqt-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtandroidextras-everywhere-src-5.12.9.tar.xz";
      sha256 = "d6ab58d382feb1d79b7f28033eaa15ecab0c1f97c760fad50f20608189ab1a95";
      name = "qtandroidextras-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtbase-everywhere-src-5.12.9.tar.xz";
      sha256 = "331dafdd0f3e8623b51bd0da2266e7e7c53aa8e9dc28a8eb6f0b22609c5d337e";
      name = "qtbase-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtcanvas3d-everywhere-src-5.12.9.tar.xz";
      sha256 = "351b105507b97e61eef17a5ce8a96fe090a523101e41c20ea373266203dd3ca0";
      name = "qtcanvas3d-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtcharts-everywhere-src-5.12.9.tar.xz";
      sha256 = "9fc2a64a96b73746389c257684af557e70c5360bead53d61d059f968efdc5b04";
      name = "qtcharts-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtconnectivity-everywhere-src-5.12.9.tar.xz";
      sha256 = "e5457ebc22059954bba6a08b03fd1e6f30e4c8f3146636065bf12c2e6044f41c";
      name = "qtconnectivity-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtdatavis3d-everywhere-src-5.12.9.tar.xz";
      sha256 = "0cd4f7535bf26e4e59f89fac991fc8a400bd6193680578f31693235f185f4562";
      name = "qtdatavis3d-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtdeclarative-everywhere-src-5.12.9.tar.xz";
      sha256 = "c11ae68aedcdea7e721ec22a95265ac91b5e128a5c12d3b61b5b732d3a02be80";
      name = "qtdeclarative-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtdoc-everywhere-src-5.12.9.tar.xz";
      sha256 = "a9d751af85a07bdfc2a30e8f1b08aa249547a8100801f286e77280a9c9ede624";
      name = "qtdoc-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtgamepad-everywhere-src-5.12.9.tar.xz";
      sha256 = "da3333af6b9dccd7dd3a25b01de65e317fe4b70b9d39eeb84e01c232063211fe";
      name = "qtgamepad-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtgraphicaleffects-everywhere-src-5.12.9.tar.xz";
      sha256 = "1eb4b913d5cb6d0b46a231288b9717f4785fbd212936e98a8b2a8c9024e3a8bf";
      name = "qtgraphicaleffects-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtimageformats-everywhere-src-5.12.9.tar.xz";
      sha256 = "cd8193698f830cce30959564c191e7bb698877aca3a263c652b4a23907c72b6a";
      name = "qtimageformats-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtlocation-everywhere-src-5.12.9.tar.xz";
      sha256 = "be31870104af2910690850c4e28bab3ccb76f1aa8deef1e870bcbc6b276aa2c1";
      name = "qtlocation-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtmacextras-everywhere-src-5.12.9.tar.xz";
      sha256 = "5458f3e13c37eb8bff8588b29703fb33b61d5ea19989c56c99d36f221e269f35";
      name = "qtmacextras-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtmultimedia-everywhere-src-5.12.9.tar.xz";
      sha256 = "59a2f2418cefe030094687dff0846fb8957abbc0e060501a4fee40cb4a52838c";
      name = "qtmultimedia-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtnetworkauth-everywhere-src-5.12.9.tar.xz";
      sha256 = "a0979689eda667e299fd9cf5a8859bd9c37eabc0a6d9738103a1143035baf0e4";
      name = "qtnetworkauth-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtpurchasing-everywhere-src-5.12.9.tar.xz";
      sha256 = "565587811b3cfd201907d3fcbf7120783de32a4d1d3c59a9efff3720cf0af3e5";
      name = "qtpurchasing-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtquickcontrols-everywhere-src-5.12.9.tar.xz";
      sha256 = "d89084ebccf155f4c966d4a2a188e6e870c37535a7751740960f5c38088373f6";
      name = "qtquickcontrols-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtquickcontrols2-everywhere-src-5.12.9.tar.xz";
      sha256 = "ea1c2864630c6ba2540228f81ec5b582619d5ce9e4cb98e91109b4181a65a31d";
      name = "qtquickcontrols2-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtremoteobjects-everywhere-src-5.12.9.tar.xz";
      sha256 = "f87af7e9931280f2b44a529dc174cae14247e1b50f9dc9bde8966adb0406babd";
      name = "qtremoteobjects-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtscript-everywhere-src-5.12.9.tar.xz";
      sha256 = "8f2e12e37ff1e7629923cf3b9d446f85e005b2248386e33879ba3b790f1416df";
      name = "qtscript-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtscxml-everywhere-src-5.12.9.tar.xz";
      sha256 = "d68d04d83366f11b10a101766baf5253e53ad76a683e0bc15e7dd403d475e61c";
      name = "qtscxml-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtsensors-everywhere-src-5.12.9.tar.xz";
      sha256 = "77054e2449bcac786cc8f07c0d65c503a22bc629af4844259ff0def27b9889e9";
      name = "qtsensors-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtserialbus-everywhere-src-5.12.9.tar.xz";
      sha256 = "08b16363a47f9b41f87e3b7cf63eaed2435bb6b7e27775c9717ff863e56141ed";
      name = "qtserialbus-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtserialport-everywhere-src-5.12.9.tar.xz";
      sha256 = "24a10b65b03fc598acd30f4a52b0b71218e9c03ec4bb31a4ca50aae1b52a986d";
      name = "qtserialport-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtspeech-everywhere-src-5.12.9.tar.xz";
      sha256 = "2efdaf5f49d2fad4a6c4cde12dfee2ff2c66ab4298f22d6c203ecd6019186847";
      name = "qtspeech-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtsvg-everywhere-src-5.12.9.tar.xz";
      sha256 = "32ec251e411d31734b873dd82fd68b6a3142227fdf06fe6ad879f16997fb98d2";
      name = "qtsvg-everywhere-src-5.12.9.tar.xz";
    };
  };
  qttools = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qttools-everywhere-src-5.12.9.tar.xz";
      sha256 = "002dc23410a9d1af6f1cfc696ee18fd3baeddbbfeb9758ddb04bbdb17b2fffdf";
      name = "qttools-everywhere-src-5.12.9.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qttranslations-everywhere-src-5.12.9.tar.xz";
      sha256 = "50bd3a329e86f14af05ef0dbef94c7a6cd6c1f89ca4d008088a44ba76e6ecf40";
      name = "qttranslations-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtvirtualkeyboard-everywhere-src-5.12.9.tar.xz";
      sha256 = "7598ee3312a2f4e72edf363c16c506740a8b91c5c06544da068a3c0d73f7f807";
      name = "qtvirtualkeyboard-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwayland-everywhere-src-5.12.9.tar.xz";
      sha256 = "6f416948a98586b9c13c46b36be5ac6bb96a1dde9f50123b5e6dcdd102e9d77e";
      name = "qtwayland-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwebchannel-everywhere-src-5.12.9.tar.xz";
      sha256 = "d55a06a0929c86664496e1113e74425d56d175916acd8abbb95c371eb16b43eb";
      name = "qtwebchannel-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwebengine-everywhere-src-5.12.9.tar.xz";
      sha256 = "27a9a19e4deb5e7a0fabc13e38fe5a8818730c92f6a343b9084aa17977468e25";
      name = "qtwebengine-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwebglplugin-everywhere-src-5.12.9.tar.xz";
      sha256 = "cb7ba4cb66900e5d4315809e2b5ad3e4e381d576a14f6224f8ea58373f997c42";
      name = "qtwebglplugin-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwebsockets-everywhere-src-5.12.9.tar.xz";
      sha256 = "08a92c36d52b4d93a539a950698bb2912ea36055015d421f874bf672637f21ef";
      name = "qtwebsockets-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwebview-everywhere-src-5.12.9.tar.xz";
      sha256 = "3e0506411d101cc08232946bcacef2fb90884c27eb91eeb97a1a68ed3788a7b6";
      name = "qtwebview-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtwinextras-everywhere-src-5.12.9.tar.xz";
      sha256 = "7bab5053197148a5e1609cab12331e4a3f2e1a86bcbde137948330b288803754";
      name = "qtwinextras-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtx11extras-everywhere-src-5.12.9.tar.xz";
      sha256 = "09432392641b56205cbcda6be89d0835bfecad64ad61713a414b951b740c9cec";
      name = "qtx11extras-everywhere-src-5.12.9.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.9";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.9/submodules/qtxmlpatterns-everywhere-src-5.12.9.tar.xz";
      sha256 = "8d0e92fce6b4cbe7f1ecd1e90f6c7d71681b9b8870a577c0b18cadd93b8713b2";
      name = "qtxmlpatterns-everywhere-src-5.12.9.tar.xz";
    };
  };
}
