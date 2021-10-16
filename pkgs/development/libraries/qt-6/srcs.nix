# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/6.3
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qt3d-everywhere-src-6.3.0.tar.xz";
      sha256 = "1qadnm2i2cgzigzq2wl0id5wzmc1p6zls4mrg1w8hd5d1lw65rvl";
      name = "qt3d-everywhere-src-6.3.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qt5compat-everywhere-src-6.3.0.tar.xz";
      sha256 = "0gkis7504qdpavimkx33zl9082r4rfa2v4iba4a943f5h3krn69b";
      name = "qt5compat-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtactiveqt-everywhere-src-6.3.0.tar.xz";
      sha256 = "01sziyhzmvqn1flw6y73aszqll1yijxxc7hyzkd269zbmpm42l4c";
      name = "qtactiveqt-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtbase-everywhere-src-6.3.0.tar.xz";
      sha256 = "168g39xiasriwpny9rf4alx3k8gnkffqjqm1n2rr5xsp6gjalrdq";
      name = "qtbase-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtcharts-everywhere-src-6.3.0.tar.xz";
      sha256 = "1k9ngvl94xd5xr34ycwvchvzih037yvfzvdf625cik21yv2n49v7";
      name = "qtcharts-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtconnectivity-everywhere-src-6.3.0.tar.xz";
      sha256 = "06p6n23y2a6nca0rzdli6zl7m2i42h2pm28092zb4vd578p17xwq";
      name = "qtconnectivity-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtdatavis3d-everywhere-src-6.3.0.tar.xz";
      sha256 = "138dkvarvh45j4524y1piw0dm2j16s3lk5pazbggi3xjnbrjwl89";
      name = "qtdatavis3d-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtdeclarative-everywhere-src-6.3.0.tar.xz";
      sha256 = "0dxa9j8cxfd86nqpvxvzxd1jdlw8h0xxqvsiv9jlyb9bvhlv156j";
      name = "qtdeclarative-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtdoc-everywhere-src-6.3.0.tar.xz";
      sha256 = "0r9giv6xpg6zhghrrv4chlk1cimmiw93cj6rdf4rkf2g3qmgv6d8";
      name = "qtdoc-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtimageformats-everywhere-src-6.3.0.tar.xz";
      sha256 = "1vxbjdfy1zya4pgcl4483912aw7ip0d768xmnrz2md3mxlbhsp82";
      name = "qtimageformats-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtlanguageserver-everywhere-src-6.3.0.tar.xz";
      sha256 = "1apfkq5grxkx69d8x7gmj19klr3jypsz1csw6r00q7hf0vvxiakh";
      name = "qtlanguageserver-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtlottie-everywhere-src-6.3.0.tar.xz";
      sha256 = "1svxz5ndljhrn52vyyr1yziar63ksjz78mvaxfhjgdd5pc5mgnrr";
      name = "qtlottie-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtmultimedia-everywhere-src-6.3.0.tar.xz";
      sha256 = "0gpylyrjkks27y5bfaxqs7idj0wyscpn1kh51i4ahx19z1zj8l6h";
      name = "qtmultimedia-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtnetworkauth-everywhere-src-6.3.0.tar.xz";
      sha256 = "17q6v4d2qglw88gd2i9m4cvvacpfsw6a544g0ch8a0hr56a9hfi0";
      name = "qtnetworkauth-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtpositioning-everywhere-src-6.3.0.tar.xz";
      sha256 = "0vi3123pa9pc4xqh6rgxwz40xvvl4w0x09fn6kdld8s5nbv51vg9";
      name = "qtpositioning-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtquick3d-everywhere-src-6.3.0.tar.xz";
      sha256 = "0zijxf33v5b2hrwppp4gr1i1dscdxqjjcb8a48c4ny0zxv8mpl0a";
      name = "qtquick3d-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtquicktimeline-everywhere-src-6.3.0.tar.xz";
      sha256 = "06hwygywqc6kqs2ss8ng6ymjs3m72r51x2lzppjnpz4y2lqskw4z";
      name = "qtquicktimeline-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtremoteobjects-everywhere-src-6.3.0.tar.xz";
      sha256 = "0v2ax6xynv13z1dqnklnvfxxdhh9fallrjdmqpkmkydgy163zckm";
      name = "qtremoteobjects-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtscxml-everywhere-src-6.3.0.tar.xz";
      sha256 = "1w3hi9c5v0lji59pkk0dhaq3xly9skf3jsm93gxj0y9nmkbdpc09";
      name = "qtscxml-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtsensors-everywhere-src-6.3.0.tar.xz";
      sha256 = "0j4ppqn8m04hfqrzrmp80fmwpr474arcycf58jypm17fnlrwfmy7";
      name = "qtsensors-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtserialbus-everywhere-src-6.3.0.tar.xz";
      sha256 = "1mi76sxh21wj1b1myqrzaaspf1iwa4bxr342p1b6krrnrf4ckxnj";
      name = "qtserialbus-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtserialport-everywhere-src-6.3.0.tar.xz";
      sha256 = "0kxnblyk8bw02bdjsnjbblczg0dvj7ys95bpr2w49h4cshs6kggf";
      name = "qtserialport-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtshadertools-everywhere-src-6.3.0.tar.xz";
      sha256 = "0v5xmyc9d3vacvdm2zpancqqmsvaz0635cba2aym9hipkndrb62l";
      name = "qtshadertools-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtsvg-everywhere-src-6.3.0.tar.xz";
      sha256 = "1qxhilxbk7wgnah7qlfcr5gsn19626dp6dc260wh8r1zgr6m0r1i";
      name = "qtsvg-everywhere-src-6.3.0.tar.xz";
    };
  };
  qttools = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qttools-everywhere-src-6.3.0.tar.xz";
      sha256 = "175is0yf74vdxlmcb9nvm86n6m7qj54mhiwkhyi84mwjxa44dsgw";
      name = "qttools-everywhere-src-6.3.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qttranslations-everywhere-src-6.3.0.tar.xz";
      sha256 = "1cs06kiv34zdkicxdjhxydv5rn1ylf4z2f4jl4a9ajm3jbw4xpg4";
      name = "qttranslations-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtvirtualkeyboard-everywhere-src-6.3.0.tar.xz";
      sha256 = "0wv54zmr9chwx1bds5b2j1436ynq6b5lbv7lbj7sycjlrxdg3al9";
      name = "qtvirtualkeyboard-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtwayland-everywhere-src-6.3.0.tar.xz";
      sha256 = "1411l2rc399bj6r36wd8n06a0rpdxkhmr0mashc5kz1zwkv6gdg7";
      name = "qtwayland-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtwebchannel-everywhere-src-6.3.0.tar.xz";
      sha256 = "03p4ggi9dk11q3zqw29awwxvddgfb3nsrrm58q053y0zlclc9i7b";
      name = "qtwebchannel-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtwebengine-everywhere-src-6.3.0.tar.xz";
      sha256 = "0g899mn6fx9w0mb9dm7y25x3d9gcy8ramwbcpk8pmjqxv1fv8090";
      name = "qtwebengine-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtwebsockets-everywhere-src-6.3.0.tar.xz";
      sha256 = "0qb39qnli5wshrnzr9kbdrbddzi2l0y9vg3b1mbdkdv0x6gs0670";
      name = "qtwebsockets-everywhere-src-6.3.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.3.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.0/submodules/qtwebview-everywhere-src-6.3.0.tar.xz";
      sha256 = "0mi1fkxz4mags32ld8km4svsnvbai0i81398f435sd1n9ach3gfy";
      name = "qtwebview-everywhere-src-6.3.0.tar.xz";
    };
  };
}
