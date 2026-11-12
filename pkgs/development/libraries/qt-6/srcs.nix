# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qt3d-everywhere-src-6.12.0.tar.xz";
      sha256 = "16pmzvvjai77yphn2d1r20y1ys5208i3dm7d3jbrwv2wjj4p8vyi";
      name = "qt3d-everywhere-src-6.12.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qt5compat-everywhere-src-6.12.0.tar.xz";
      sha256 = "0ki6b75hng2sml84yj6w98vlhssmgxzynwqwldzjlccm6wl1rkvq";
      name = "qt5compat-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtactiveqt-everywhere-src-6.12.0.tar.xz";
      sha256 = "00qx8l4663mgr8hxjzxf1mysj1svnqj2y2m7qj2w11hmg5l2bf83";
      name = "qtactiveqt-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtbase-everywhere-src-6.12.0.tar.xz";
      sha256 = "01qk2cw34xk60v0i6gipab0r3gvann7ndmw8iimzr03v7hbbsld9";
      name = "qtbase-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtcanvaspainter-everywhere-src-6.12.0.tar.xz";
      sha256 = "1qhra4j0f0yjwr1k426lgagv0akhw9gwlij32pimhz7g7dy79h09";
      name = "qtcanvaspainter-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtcharts-everywhere-src-6.12.0.tar.xz";
      sha256 = "1yrb0v196yhcmk2sp30bhq7458z69y19bfx192974y2w8nchapnw";
      name = "qtcharts-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtconnectivity-everywhere-src-6.12.0.tar.xz";
      sha256 = "0m0ra93qzrjg62jzb9671s691h7nhix0r522ib7pyhqz5kqgflgd";
      name = "qtconnectivity-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtdatavis3d-everywhere-src-6.12.0.tar.xz";
      sha256 = "1p4qmaxqsd3yac5rg5sxizc572dlq5sv0dg3d5zzz08yxd4bjyaz";
      name = "qtdatavis3d-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtdeclarative-everywhere-src-6.12.0.tar.xz";
      sha256 = "0q4jkj41ws23w0p7im2p65qxwxm382kxzydfkfskp5z10ck3l7ri";
      name = "qtdeclarative-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtdoc-everywhere-src-6.12.0.tar.xz";
      sha256 = "0zm5q85dh63y74s88a4m8cvbssyr882zm3g2zhsc5i2i2l89vr74";
      name = "qtdoc-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtgraphs-everywhere-src-6.12.0.tar.xz";
      sha256 = "132d79sm1k6f8ds7gh35c32dscayjwy8w7xhjhfhaislg1lfki0q";
      name = "qtgraphs-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtgrpc-everywhere-src-6.12.0.tar.xz";
      sha256 = "177gqcp0j5hzxia18zbfli1fkvxr7p0sr6ia7dy3vszvwp25463p";
      name = "qtgrpc-everywhere-src-6.12.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qthttpserver-everywhere-src-6.12.0.tar.xz";
      sha256 = "190lg1ymc0hzx391rrrmsrcylgbsib0s9hgnll797l2i8lk41q7d";
      name = "qthttpserver-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtimageformats-everywhere-src-6.12.0.tar.xz";
      sha256 = "0qkpyr2jha8kj79hzs4lxp3n71ry2y12c5hxgxm6ppmqblmi6hq9";
      name = "qtimageformats-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtlanguageserver-everywhere-src-6.12.0.tar.xz";
      sha256 = "0va2g8xynrp9jgpl256bsa05mnpqznxr2kmmn1gnrh30fgiij8am";
      name = "qtlanguageserver-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtlocation-everywhere-src-6.12.0.tar.xz";
      sha256 = "03gmn32419mri9p5znq7qnnlpydbiqmadzg9as3mxfcygkard1i1";
      name = "qtlocation-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz";
      sha256 = "0zlrbmdblfyy53xqjss0a7hzzvdnmfy08y2fra66yrpj2z4h93vb";
      name = "qtlottie-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtmultimedia-everywhere-src-6.12.0.tar.xz";
      sha256 = "0bd6jgm59zawwinm2szq3y3pav27rrfhz52wd2ha4yr5chxzahri";
      name = "qtmultimedia-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtnetworkauth-everywhere-src-6.12.0.tar.xz";
      sha256 = "1n2yfqwppcyr92ppg8svjg2da3y3a9xaqwx8v9sigli4lzhppm0p";
      name = "qtnetworkauth-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtopenapi-everywhere-src-6.12.0.tar.xz";
      sha256 = "0ix8lm3zi1fzl43k8z7y09g4lpqjp3nlxv3925w3w8yjba5nn9s6";
      name = "qtopenapi-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtpositioning-everywhere-src-6.12.0.tar.xz";
      sha256 = "0qv7wyb0c3r7aqwsy56zsw4avxr56fzqp4z7l02knhf7z88d8q5h";
      name = "qtpositioning-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtquick3d-everywhere-src-6.12.0.tar.xz";
      sha256 = "17j25rd516m6g4n00qld7qim1gvnnchfh2kpzqraddazsbdnxvbc";
      name = "qtquick3d-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtquick3dphysics-everywhere-src-6.12.0.tar.xz";
      sha256 = "10dl30lmf7xrfsawh2jrm2gxgl5hyr8awrbasdcwfxs6gqa27nwd";
      name = "qtquick3dphysics-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtquickeffectmaker-everywhere-src-6.12.0.tar.xz";
      sha256 = "1b335jf73ywhrzvr9rihhxy8yb4rcplqyzmz3jcx7s9mk0y8q319";
      name = "qtquickeffectmaker-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtquicktimeline-everywhere-src-6.12.0.tar.xz";
      sha256 = "06fsz0161jfbdkn64irkd04mj1p681pm485dy09w2y0lhhy1a6b9";
      name = "qtquicktimeline-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtremoteobjects-everywhere-src-6.12.0.tar.xz";
      sha256 = "02amlpw51giz993d1x6nn9x2spay4nc5zgg99bsxg16cyy0gdyjl";
      name = "qtremoteobjects-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtscxml-everywhere-src-6.12.0.tar.xz";
      sha256 = "10w3wcml88ypjs6cl4vr0gm9ad1nklj6ybs1bb6nn9c3ndslih5d";
      name = "qtscxml-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtsensors-everywhere-src-6.12.0.tar.xz";
      sha256 = "144h65071qpvvaxqwkn37rrjakc0xixislqvg9vyz340x25za7c6";
      name = "qtsensors-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtserialbus-everywhere-src-6.12.0.tar.xz";
      sha256 = "0f6zbdgq2z59di72zygd17q9i01igihhnz49lxdhrlprmwjcr68h";
      name = "qtserialbus-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtserialport-everywhere-src-6.12.0.tar.xz";
      sha256 = "1hvipnycsrwxn7kkxaxshhn4d760bhjl24zsr5bnwipf9sjqd25s";
      name = "qtserialport-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtshadertools-everywhere-src-6.12.0.tar.xz";
      sha256 = "1ax2zsxkr1wq04p3zqcpjk34vwmxf6yz5sxdvjgz7bhsdr1lzn67";
      name = "qtshadertools-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtspeech-everywhere-src-6.12.0.tar.xz";
      sha256 = "1nrk978dn9nyma2mav1xyh96i6gvpy12bazy80vk9aalxrdwwq4s";
      name = "qtspeech-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtsvg-everywhere-src-6.12.0.tar.xz";
      sha256 = "0cck0aj78cbm04x7334zlq95jg95sgsgf3mnp6qqfyf99r9kkaz4";
      name = "qtsvg-everywhere-src-6.12.0.tar.xz";
    };
  };
  qttasktree = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz";
      sha256 = "0pkbb4srdxphkxp7dwlx0dxd7ckrdaaly3fpiyy7zn623w6sr36j";
      name = "qttasktree-everywhere-src-6.12.0.tar.xz";
    };
  };
  qttools = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qttools-everywhere-src-6.12.0.tar.xz";
      sha256 = "14q62swgpfmxdrpqnaraq9mz7155xrf12pxdf2j8cr2924v8zawd";
      name = "qttools-everywhere-src-6.12.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qttranslations-everywhere-src-6.12.0.tar.xz";
      sha256 = "1fvbdxzkb5dzi8psng5p180pp89yh1lvnyfq7gr77wnn6069r4l5";
      name = "qttranslations-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz";
      sha256 = "0w016mngzpmpcbxpljdm3dznms8fyphyflvqknaqd3v4yhl3dbia";
      name = "qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtwayland-everywhere-src-6.12.0.tar.xz";
      sha256 = "00jd9v3ipjzdbb6c8jkajrn5qki8a0zsbrmj78530g5vy6ydj55f";
      name = "qtwayland-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtwebchannel-everywhere-src-6.12.0.tar.xz";
      sha256 = "09x3vjigy1kkvs49vxwxbc6nz1snlmlwxzd42v6c2csvhmjgpzcs";
      name = "qtwebchannel-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtwebsockets-everywhere-src-6.12.0.tar.xz";
      sha256 = "0cas8nvia4hx93bzw881r979zpv8i7lp6505xa6zmyymbhv0ls91";
      name = "qtwebsockets-everywhere-src-6.12.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.12.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz";
      sha256 = "0kjh5iwn18w5658d210l666a50icgpdscb3a934pykb14li69q5y";
      name = "qtwebview-everywhere-src-6.12.0.tar.xz";
    };
  };
}
