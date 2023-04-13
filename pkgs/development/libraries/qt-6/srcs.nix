# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qt3d-everywhere-src-6.4.3.tar.xz";
      sha256 = "0w9xmsrd3mqbm5vf1m8cv67kcjrcbjnfmm6fmw2icg95jzwjb0m8";
      name = "qt3d-everywhere-src-6.4.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qt5compat-everywhere-src-6.4.3.tar.xz";
      sha256 = "0ymak3cr36b8hyr3axxywrv153ds4kcj8p04x7p7bm93p2mlkcnl";
      name = "qt5compat-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtactiveqt-everywhere-src-6.4.3.tar.xz";
      sha256 = "0v8wf7xv5dqcw9v75a1zhhfqhmrya9q66az3awkfscjda78y2gh9";
      name = "qtactiveqt-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtbase-everywhere-src-6.4.3.tar.xz";
      sha256 = "0q0si40bmgbplczr1skacd98zkfh6mmigax4q71pnphnn3jwk1sh";
      name = "qtbase-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtcharts-everywhere-src-6.4.3.tar.xz";
      sha256 = "0in36za9iq41mc1hq62vjd8zni6amdd2b24gqngzcpdmzzsy8qaa";
      name = "qtcharts-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtconnectivity-everywhere-src-6.4.3.tar.xz";
      sha256 = "17acli5wksd793v145mv8a4ld59v8g9dvv32wxlyvdsarha2137r";
      name = "qtconnectivity-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtdatavis3d-everywhere-src-6.4.3.tar.xz";
      sha256 = "15brg1gcx2am3wbr54lx20fw1q42gryjxxnxf600nmk3nrfsqy69";
      name = "qtdatavis3d-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtdeclarative-everywhere-src-6.4.3.tar.xz";
      sha256 = "15d73d957zfhls3ny322i1n9iqvg2nxk8swi00v5w4w8p6rx3pk7";
      name = "qtdeclarative-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtdoc-everywhere-src-6.4.3.tar.xz";
      sha256 = "10w12bsfwmxw6z4n50mv653q6vj7bcb7r0pmik52kxi9sr6w7skk";
      name = "qtdoc-everywhere-src-6.4.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qthttpserver-everywhere-src-6.4.3.tar.xz";
      sha256 = "0yf162pxm55aybm62z1qqf3h9ff39iy72ffpxk775fbrqynxqyn3";
      name = "qthttpserver-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtimageformats-everywhere-src-6.4.3.tar.xz";
      sha256 = "165pk7z2k0ymzkm1r8fjykc6hlxdrpc2b0ysqlbldf3l5q35izqa";
      name = "qtimageformats-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtlanguageserver-everywhere-src-6.4.3.tar.xz";
      sha256 = "0xbrsg1z9p9wwx1zhh9birb44lb8ri1c6afjlv2cf69f8h31120f";
      name = "qtlanguageserver-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtlottie-everywhere-src-6.4.3.tar.xz";
      sha256 = "0gb9y4c9d1x548hpvcjbgr0pvw3v4c1vicqy6ppavv368ph54v7z";
      name = "qtlottie-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtmultimedia-everywhere-src-6.4.3.tar.xz";
      sha256 = "003xav0vxlh6i6l0nk9m7ikaa86nfxk2xarjw2gfb89dw5lj99x4";
      name = "qtmultimedia-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtnetworkauth-everywhere-src-6.4.3.tar.xz";
      sha256 = "1rbaf73ijvr6y91scdyk5cjnsm930yj2ck2gnvxwif7lfajmn4ad";
      name = "qtnetworkauth-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtpositioning-everywhere-src-6.4.3.tar.xz";
      sha256 = "036pph2hy2wzr1z6gs3zc688zxifnkc001p9ba9y44kwsghv265j";
      name = "qtpositioning-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtquick3d-everywhere-src-6.4.3.tar.xz";
      sha256 = "0l40vkada3l1zkz042lcg9ybkqd3bg6wlc0vzngr76s4bmb8v8vq";
      name = "qtquick3d-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtquick3dphysics-everywhere-src-6.4.3.tar.xz";
      sha256 = "05fv5mbcfqzmrr3ciqlx3vw5b6agk3kpb4r548h0hcacqjiyi1mb";
      name = "qtquick3dphysics-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtquicktimeline-everywhere-src-6.4.3.tar.xz";
      sha256 = "199xbvjq1xg1lzkkq4ilbp1jiikiqg9khbzijz3ribx3qd3w821q";
      name = "qtquicktimeline-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtremoteobjects-everywhere-src-6.4.3.tar.xz";
      sha256 = "0shq1i26k76nymvlj48l5n4afn06j6kbca463lclk8nbg7glg54w";
      name = "qtremoteobjects-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtscxml-everywhere-src-6.4.3.tar.xz";
      sha256 = "0fignzvz9wc37s94bdnqd7z8x6a5m3adbiz32gkh4k23dl0jqwpy";
      name = "qtscxml-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtsensors-everywhere-src-6.4.3.tar.xz";
      sha256 = "0j5wp93hlf1gpb9y55llad9pimjz20hp5w5xl0v6fic953x68faz";
      name = "qtsensors-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtserialbus-everywhere-src-6.4.3.tar.xz";
      sha256 = "0rj3nfs017vmp8i7f1hg2mrav7fkwh6cby803ib4xw6i2rsnli5n";
      name = "qtserialbus-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtserialport-everywhere-src-6.4.3.tar.xz";
      sha256 = "1plmzkn1g00g0vrw5n9kawq1y6fj0cgbryrr5a59m8zgcy8av5sz";
      name = "qtserialport-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtshadertools-everywhere-src-6.4.3.tar.xz";
      sha256 = "1y384xw3jb1x4z3qzwzjxp7ymg20qn4sb4i7sq5s4sg7wd6bfj66";
      name = "qtshadertools-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtspeech-everywhere-src-6.4.3.tar.xz";
      sha256 = "1qja4n2wkkxkcczr1afi8d083qq4lrngkvj698w1s1habqcx1q3r";
      name = "qtspeech-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtsvg-everywhere-src-6.4.3.tar.xz";
      sha256 = "0jlshycc0cy3ja652g6jb51p4q31dsxfsz28brq9h67qdj45ycc8";
      name = "qtsvg-everywhere-src-6.4.3.tar.xz";
    };
  };
  qttools = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qttools-everywhere-src-6.4.3.tar.xz";
      sha256 = "14d0qmqdyrz524srb5iwn5j2fm136582bs32zs7axlswrllzhzc6";
      name = "qttools-everywhere-src-6.4.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qttranslations-everywhere-src-6.4.3.tar.xz";
      sha256 = "0b4pprdczbnk1gvda2bs1fg84yinii9ih201m2l4k5nl01w6prbr";
      name = "qttranslations-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtvirtualkeyboard-everywhere-src-6.4.3.tar.xz";
      sha256 = "1r8fvqjmh18x89snxflzci1vinf7jvflfjihidffc02vdwi8aiiz";
      name = "qtvirtualkeyboard-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtwayland-everywhere-src-6.4.3.tar.xz";
      sha256 = "12a7pi39zn7miyli6ywhkfx7vh0sl2h5iddp226f80acizd63cf6";
      name = "qtwayland-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtwebchannel-everywhere-src-6.4.3.tar.xz";
      sha256 = "1a7kpsy5c9vmwk69csnni6n6kn4zpvbf9fwbr1j4mrzhhx2h8mg9";
      name = "qtwebchannel-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtwebengine-everywhere-src-6.4.3.tar.xz";
      sha256 = "09995fhpzkpycjgad4s2wh5wx3vxl95h35cd3fj7kp516vvmmy2m";
      name = "qtwebengine-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtwebsockets-everywhere-src-6.4.3.tar.xz";
      sha256 = "13s5im5ms7bza9f9dy6ahnxb5d9ndgvxfw83asp86pjwnmz3a9yy";
      name = "qtwebsockets-everywhere-src-6.4.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.4.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.3/submodules/qtwebview-everywhere-src-6.4.3.tar.xz";
      sha256 = "0hz8ydf45nfxdsp2srff1yq2qpan50flwyw2aa4js52y95q1g5ai";
      name = "qtwebview-everywhere-src-6.4.3.tar.xz";
    };
  };
}
