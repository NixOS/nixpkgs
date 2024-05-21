# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qt3d-everywhere-src-6.7.1.tar.xz";
      sha256 = "0yrmsn02ykd3k59mqvvjf4rwmhbx05i77blv6n41nsmxh6nc17pm";
      name = "qt3d-everywhere-src-6.7.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qt5compat-everywhere-src-6.7.1.tar.xz";
      sha256 = "02b011244vnq6v0fx78h084ff1nmxbzyrwryxrqc33qm37jbpi21";
      name = "qt5compat-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtactiveqt-everywhere-src-6.7.1.tar.xz";
      sha256 = "0id5nmk8l0gyfsngq782pyg5ag5syr21dvmd4dy4kbs3w4hqf6fb";
      name = "qtactiveqt-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtbase-everywhere-src-6.7.1.tar.xz";
      sha256 = "06ffdad2g0pcsyzicj8rgvixyx7ihfmgzvqlwxhxid6cpnhqscxp";
      name = "qtbase-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtcharts-everywhere-src-6.7.1.tar.xz";
      sha256 = "132x7l43fm6m3jw3r8myqwr0kras161sg0ddkgaz04n8ndd8fdn2";
      name = "qtcharts-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtconnectivity-everywhere-src-6.7.1.tar.xz";
      sha256 = "1jrxlwh5avhri0ykzvqwy2y2r3qazs05vn5ask4l3ga2wkxhl0bh";
      name = "qtconnectivity-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtdatavis3d-everywhere-src-6.7.1.tar.xz";
      sha256 = "0z0scbmknq6bh9dqnicm3g24bf313bv3pa78lwdaggzg5z6i03ga";
      name = "qtdatavis3d-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtdeclarative-everywhere-src-6.7.1.tar.xz";
      sha256 = "074zzmc1acha41dnz51gqs9x3niqyks5g356p22r6n9gxnb5q4w1";
      name = "qtdeclarative-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtdoc-everywhere-src-6.7.1.tar.xz";
      sha256 = "0kak2d0n8fbk70zbi7ln0bda46fcqln0p43qzzid6bmc8h42ws6d";
      name = "qtdoc-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtgraphs-everywhere-src-6.7.1.tar.xz";
      sha256 = "0f5wzzs6w2cq81rzx98lyc40jw37p8708dmdm7sgx8l93jclln3i";
      name = "qtgraphs-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtgrpc-everywhere-src-6.7.1.tar.xz";
      sha256 = "186g1bndldf74hg3922vbw01mw44jy5l2y71zcgkw6r6y7w3994w";
      name = "qtgrpc-everywhere-src-6.7.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qthttpserver-everywhere-src-6.7.1.tar.xz";
      sha256 = "1nxvyiyi9y7vgxdywrn2rlyfxq4snnvxlw2awzawh905l8g8687d";
      name = "qthttpserver-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtimageformats-everywhere-src-6.7.1.tar.xz";
      sha256 = "17z7vywfs4qqkyzqmfj8jis84f8l4bw6323b8w0d0r0hfy7vjcx7";
      name = "qtimageformats-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtlanguageserver-everywhere-src-6.7.1.tar.xz";
      sha256 = "1yclzaj93ygy5kyxi4ri6i8yzxwlikkn0hldszci03knchadmz50";
      name = "qtlanguageserver-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtlocation-everywhere-src-6.7.1.tar.xz";
      sha256 = "02464sv5gg8z5pmnwjba584fqw1vi0xlzlish9gs7zf95s61fw1q";
      name = "qtlocation-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtlottie-everywhere-src-6.7.1.tar.xz";
      sha256 = "0z52jh4mw1pqvcldblwn4igq888hg0p1bgnhndi89rnkrdli1pka";
      name = "qtlottie-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtmultimedia-everywhere-src-6.7.1.tar.xz";
      sha256 = "0gndclyixwj0g5yzfpamr2fi0q288nn4h9gy76yz2nvzf91iavb5";
      name = "qtmultimedia-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtnetworkauth-everywhere-src-6.7.1.tar.xz";
      sha256 = "0pap87c4km4isygmhdmamrfhis69jdj6j2fjgccxsb2gqc2klaq1";
      name = "qtnetworkauth-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtpositioning-everywhere-src-6.7.1.tar.xz";
      sha256 = "0lsgh01bnca766h3iv55fc9arrrd9ck25zlfgkljclfkp130sasw";
      name = "qtpositioning-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtquick3d-everywhere-src-6.7.1.tar.xz";
      sha256 = "1s9zm6akk8c0r30mabdipqybhdxihq4riapxph221nmvgz60sfff";
      name = "qtquick3d-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtquick3dphysics-everywhere-src-6.7.1.tar.xz";
      sha256 = "0xdxrx41f4kssjnmwrj1fza3zbr5awc73mbbb9gqxc43k11523rg";
      name = "qtquick3dphysics-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtquickeffectmaker-everywhere-src-6.7.1.tar.xz";
      sha256 = "1qindhqqsp9y5gf82jga1fyvs81l1pli8b3rf5f4a9pqg6n140jb";
      name = "qtquickeffectmaker-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtquicktimeline-everywhere-src-6.7.1.tar.xz";
      sha256 = "0i2pf9a1y50589ly00qaiik8q7ydmw2vf6jg2nq3r8dphx6j0y9d";
      name = "qtquicktimeline-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtremoteobjects-everywhere-src-6.7.1.tar.xz";
      sha256 = "1x6c95wkxd28a2dplv0956rqfr5kw96f33aqvncxcm7qp80jn0g7";
      name = "qtremoteobjects-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtscxml-everywhere-src-6.7.1.tar.xz";
      sha256 = "0kxjcx8rp8g6rrg153xwakr3jbm1accgjmzahxkbv2g8hi942b82";
      name = "qtscxml-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtsensors-everywhere-src-6.7.1.tar.xz";
      sha256 = "1wpv1p43h40pmmy8wya6f92aysyp9z0w3yfs2af06w8gv4bllsfm";
      name = "qtsensors-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtserialbus-everywhere-src-6.7.1.tar.xz";
      sha256 = "13v2anjsdwkkm4clkcinih2118vg5nm9dafpr47h86xq8pahafai";
      name = "qtserialbus-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtserialport-everywhere-src-6.7.1.tar.xz";
      sha256 = "11jqx8j62dyd5n63222zwpk5n7sg45laa6qi98p2ylpxidwa6hz5";
      name = "qtserialport-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtshadertools-everywhere-src-6.7.1.tar.xz";
      sha256 = "1hhhg7qs28mdd9s8wah2qvpkv7760jd4i10s37cbmqmjhnly71g5";
      name = "qtshadertools-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtspeech-everywhere-src-6.7.1.tar.xz";
      sha256 = "127ba7vqqrgg7hw2c0aix3qk8vn5xh3ilh7w1k5za3pwr0aisvvc";
      name = "qtspeech-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtsvg-everywhere-src-6.7.1.tar.xz";
      sha256 = "1knb0xc662ajikbhsg1j3i6j4g97xn2759dpcga1vi18f87vim9y";
      name = "qtsvg-everywhere-src-6.7.1.tar.xz";
    };
  };
  qttools = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qttools-everywhere-src-6.7.1.tar.xz";
      sha256 = "094qv7mpzi3g9cbrlwix8qzfp64a5s4h82d1g699bws8cbgwslq9";
      name = "qttools-everywhere-src-6.7.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qttranslations-everywhere-src-6.7.1.tar.xz";
      sha256 = "1x7vwj4f3sddq5g3mpfvyqigkc0s0ggp341l0drhw3ibhxjibmq3";
      name = "qttranslations-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtvirtualkeyboard-everywhere-src-6.7.1.tar.xz";
      sha256 = "0pd8rg6qn3grlari3lgj46b85l5r6sal5g9qkf82yqkz3cyxhv3v";
      name = "qtvirtualkeyboard-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtwayland-everywhere-src-6.7.1.tar.xz";
      sha256 = "081xm13gvkxg5kv9yhwlxwixcc1wz0vas7arivfhxj81wyl7dwby";
      name = "qtwayland-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtwebchannel-everywhere-src-6.7.1.tar.xz";
      sha256 = "0vyc5mfjhsyj147wxg3ldlcn3bm895p961akcc2cw2z9zknrbndr";
      name = "qtwebchannel-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtwebengine-everywhere-src-6.7.1.tar.xz";
      sha256 = "0i6w4783yz58aqxidzaz69k698344fn2h5wm1sdr8zcsc0981w2k";
      name = "qtwebengine-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtwebsockets-everywhere-src-6.7.1.tar.xz";
      sha256 = "1szy09vayk5ifd22mpz4zvwwgr5sjz3cawgnaqmcf6dqsbjac5py";
      name = "qtwebsockets-everywhere-src-6.7.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.7.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.1/submodules/qtwebview-everywhere-src-6.7.1.tar.xz";
      sha256 = "0swhdh3xvx82wz337lzwwi34xcq9na9hqnisraqxcd1p7qdqzkk4";
      name = "qtwebview-everywhere-src-6.7.1.tar.xz";
    };
  };
}
