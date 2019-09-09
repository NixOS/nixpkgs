# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qt3d-everywhere-src-5.12.3.tar.xz";
      sha256 = "8997f07c816bbc6dd43fc2171801178bc65e704d35039998530cfa49837eaa7d";
      name = "qt3d-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtactiveqt-everywhere-src-5.12.3.tar.xz";
      sha256 = "15a5fde0a069f402bea9f422d8d2c46af440d202122c6307c2a6be642d20dc0f";
      name = "qtactiveqt-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtandroidextras-everywhere-src-5.12.3.tar.xz";
      sha256 = "866b3fbcfc2cbebdb83b5adec4e5d0bd29b0e0b0762d66fb3fef0b400e37254f";
      name = "qtandroidextras-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtbase-everywhere-src-5.12.3.tar.xz";
      sha256 = "fddfd8852ef7503febeed67b876d1425160869ae2b1ae8e10b3fb0fedc5fe701";
      name = "qtbase-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtcanvas3d-everywhere-src-5.12.3.tar.xz";
      sha256 = "c0821f1232c6bcd00648af9a5d1eade8e0397c6bfff60621e0fcdfc75561baea";
      name = "qtcanvas3d-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtcharts-everywhere-src-5.12.3.tar.xz";
      sha256 = "820c94b2bf5d73e921fe99be1e3a03a6f012d96574a08e504d68db237522b3a9";
      name = "qtcharts-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtconnectivity-everywhere-src-5.12.3.tar.xz";
      sha256 = "01518cee71a8d53b9c2387f8c7facbcc2c4d63ab3b79462edfa06ba3bfeae661";
      name = "qtconnectivity-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtdatavis3d-everywhere-src-5.12.3.tar.xz";
      sha256 = "f6d073c4575542f8ff6de3ac3b6e8dde6ae2d87e98119de7a13bc984aa967313";
      name = "qtdatavis3d-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtdeclarative-everywhere-src-5.12.3.tar.xz";
      sha256 = "839881cd6996e35c351bc7d560372ebb91e61f3688957c33248c4f31ea007fa7";
      name = "qtdeclarative-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtdoc-everywhere-src-5.12.3.tar.xz";
      sha256 = "ce5e9d0f48d108c48d742ab2127ead735270d7b525103c6cf409683d7fc8334f";
      name = "qtdoc-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtgamepad-everywhere-src-5.12.3.tar.xz";
      sha256 = "5d046869e9646912936e3622efa755d85ccc8eddba91f5b12880cfb5e6489642";
      name = "qtgamepad-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtgraphicaleffects-everywhere-src-5.12.3.tar.xz";
      sha256 = "772c98a009cc82ac290f868906c5aa719e4608ef3c5905d69ef7402b15924a73";
      name = "qtgraphicaleffects-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtimageformats-everywhere-src-5.12.3.tar.xz";
      sha256 = "db5a9e784f9c327c1e6830b1550311024cc91202d3b8dde82cd0944164298be2";
      name = "qtimageformats-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtlocation-everywhere-src-5.12.3.tar.xz";
      sha256 = "52d589be2852ada0c000b06cc411b61e521cd0797470be567fd1625bcc9d75c6";
      name = "qtlocation-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtmacextras-everywhere-src-5.12.3.tar.xz";
      sha256 = "38dedd29d07ea9e4e92a7ef28f9e03c06cf9a1525aee4f8084310c519f5b47ed";
      name = "qtmacextras-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtmultimedia-everywhere-src-5.12.3.tar.xz";
      sha256 = "a30beeb37fb284d93522e29c01fb8d12726f40e9248e80b70b1f8ab60197a301";
      name = "qtmultimedia-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtnetworkauth-everywhere-src-5.12.3.tar.xz";
      sha256 = "dd6bf334be29fb82adaeecb184779328b4ad33a069528b9954d9c07f2d889332";
      name = "qtnetworkauth-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtpurchasing-everywhere-src-5.12.3.tar.xz";
      sha256 = "a848f1e1022af38571f5ab0c4ec4b904c12fa6ef19154d44abbcaeb35156753e";
      name = "qtpurchasing-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtquickcontrols-everywhere-src-5.12.3.tar.xz";
      sha256 = "68ae03b35eaa44a24c3f663b842252053c9f2b00b18841fd39ff7d2150986f46";
      name = "qtquickcontrols-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtquickcontrols2-everywhere-src-5.12.3.tar.xz";
      sha256 = "e855e8369c3cb5a2ebcd2028a2a195ba73945fd9d5bc26134706c2fa14e99b3a";
      name = "qtquickcontrols2-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtremoteobjects-everywhere-src-5.12.3.tar.xz";
      sha256 = "3475a409127739930e0bf833cea5f7f605adc66ab25fac39b72ce4bf3039cc42";
      name = "qtremoteobjects-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtscript-everywhere-src-5.12.3.tar.xz";
      sha256 = "0f37bf032a2370bd08667aad053f5a57717ea49596c16bf6cfb32b0d6e5c1f9e";
      name = "qtscript-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtscxml-everywhere-src-5.12.3.tar.xz";
      sha256 = "70c4b1f8e23560cf54e69aeb3ded4078434e6f78e1b9573fbad1ddace5fc4b19";
      name = "qtscxml-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtsensors-everywhere-src-5.12.3.tar.xz";
      sha256 = "7f63fedf60fdf110a3fc529568c7226d7acd59cc5eaee908f4d5a969e34005fc";
      name = "qtsensors-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtserialbus-everywhere-src-5.12.3.tar.xz";
      sha256 = "792cd2d411d2ebd737f5d09580f8db479cd35f2f7e7cedb4412075ef20fcfe4d";
      name = "qtserialbus-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtserialport-everywhere-src-5.12.3.tar.xz";
      sha256 = "1faf7df4a1f9028bef1ce79330badb4e5cbbba9f717c53cafc5aea41eed1de51";
      name = "qtserialport-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtspeech-everywhere-src-5.12.3.tar.xz";
      sha256 = "ed211822765744553fb5abeb97058420668b18a50d985061d949a0e068ee64f5";
      name = "qtspeech-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtsvg-everywhere-src-5.12.3.tar.xz";
      sha256 = "f666438dbf6816b7534e539b95e3fa4405f11d7e2e2bbcde34f2db5ae0f27dc2";
      name = "qtsvg-everywhere-src-5.12.3.tar.xz";
    };
  };
  qttools = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qttools-everywhere-src-5.12.3.tar.xz";
      sha256 = "c9e92d2f0d369e44bb1a60e9fa6d970f8d9893d653212305e04be5e6daec2cd8";
      name = "qttools-everywhere-src-5.12.3.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qttranslations-everywhere-src-5.12.3.tar.xz";
      sha256 = "eefcec0a91c302548f9d948a138b8ec77d78570ce818931bd8475b1bff1205ca";
      name = "qttranslations-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtvirtualkeyboard-everywhere-src-5.12.3.tar.xz";
      sha256 = "7b83af4527310de4ab81146622f3a46677daabf05556d0e33a2e25ca2aa13b22";
      name = "qtvirtualkeyboard-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwayland-everywhere-src-5.12.3.tar.xz";
      sha256 = "f0b45ad84180730e2d5a1249eb20c6357869b4b78f45eb266c2f2b17f77d86ff";
      name = "qtwayland-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwebchannel-everywhere-src-5.12.3.tar.xz";
      sha256 = "72d1620bcc94e14caa91ddf344c84cd1288aa9479e00b1bb3b5e51f92efe088a";
      name = "qtwebchannel-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwebengine-everywhere-src-5.12.3.tar.xz";
      sha256 = "3ff3bac12d75aa0f3fd993bb7077fe411f7b0e6a3993af6f8b039d48e3dc4317";
      name = "qtwebengine-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwebglplugin-everywhere-src-5.12.3.tar.xz";
      sha256 = "23da63013101e97c4e663bb4f6dbb1c7b4386679c634680d3b8d79bcc59d26b3";
      name = "qtwebglplugin-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwebsockets-everywhere-src-5.12.3.tar.xz";
      sha256 = "258883225c5e089015c4036f31019aa8f5bb013ecd8eecd193342e606319a577";
      name = "qtwebsockets-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwebview-everywhere-src-5.12.3.tar.xz";
      sha256 = "f904e7fd7e755527e5bc4633c6f7c144065a3ffea473bf01fffb730385a983c5";
      name = "qtwebview-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtwinextras-everywhere-src-5.12.3.tar.xz";
      sha256 = "2b6319f7dd19fc19b028685c163a69f0a10e610d7554411d4660c1b5e42ada3b";
      name = "qtwinextras-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtx11extras-everywhere-src-5.12.3.tar.xz";
      sha256 = "85e3ae5177970c2d8656226d7535d0dff5764c100e55a79a59161d80754ba613";
      name = "qtx11extras-everywhere-src-5.12.3.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.3/submodules/qtxmlpatterns-everywhere-src-5.12.3.tar.xz";
      sha256 = "e0b98e7c92cd791a9b354d090788347db78f14c47579384fe22d0b650c1d8a61";
      name = "qtxmlpatterns-everywhere-src-5.12.3.tar.xz";
    };
  };
}
