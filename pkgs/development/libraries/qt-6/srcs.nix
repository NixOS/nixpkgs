# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qt3d-everywhere-src-6.11.1.tar.xz";
      sha256 = "01q11bs7vjz1s5wdrdjq904dgl2m6l7r8d3vd2kyf7lx0j78qvd6";
      name = "qt3d-everywhere-src-6.11.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qt5compat-everywhere-src-6.11.1.tar.xz";
      sha256 = "06qndy534rzabxk9yq07dsl8fj1vd72lmck11r5xbajil3d9zjyg";
      name = "qt5compat-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtactiveqt-everywhere-src-6.11.1.tar.xz";
      sha256 = "05hcnhxkajry4ha7ykmqr83p16qjipspwxid8l2rxgz80wy6aadv";
      name = "qtactiveqt-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtbase-everywhere-src-6.11.1.tar.xz";
      sha256 = "1b616gr7k8byfr2ns4vczs4kj3sznhlrlw9inpb3m8la48qllnfr";
      name = "qtbase-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtcanvaspainter-everywhere-src-6.11.1.tar.xz";
      sha256 = "1l08zp68q3wcr9v5hh82kw6jqvc1wmnrjn7h9959psx520dwcdly";
      name = "qtcanvaspainter-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtcharts-everywhere-src-6.11.1.tar.xz";
      sha256 = "0p2icmrwb6am7x2kgk9pnpa8ypi7jiscyaawgi0x31iaihqyvqrz";
      name = "qtcharts-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtconnectivity-everywhere-src-6.11.1.tar.xz";
      sha256 = "14g5h0wixqy981cnn5f8gkjbji804f18gfjkzbanxd0lljg2h191";
      name = "qtconnectivity-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtdatavis3d-everywhere-src-6.11.1.tar.xz";
      sha256 = "1b4kcqfq5q79lm70f08qiksxl36laa9dgx9ladjk2xwl1af7n6hy";
      name = "qtdatavis3d-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtdeclarative-everywhere-src-6.11.1.tar.xz";
      sha256 = "193ar0fcfzjjr7mi8i2622vip95qrr3qry949d9lyc5hf3v71rjj";
      name = "qtdeclarative-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtdoc-everywhere-src-6.11.1.tar.xz";
      sha256 = "1hd5z6prx2sbr3wxzkynrn2iyjllvkids505l2xg3p272j4b5306";
      name = "qtdoc-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtgraphs-everywhere-src-6.11.1.tar.xz";
      sha256 = "0qh43qxqg4biyrrsd78nmi4dm3dnbswa95cq8db2k3lans517cc4";
      name = "qtgraphs-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtgrpc-everywhere-src-6.11.1.tar.xz";
      sha256 = "0l52w91hd2crq6zyh5a8arv07yixnwcr2pya74bxpk2hqpq08ys3";
      name = "qtgrpc-everywhere-src-6.11.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qthttpserver-everywhere-src-6.11.1.tar.xz";
      sha256 = "01p7li9fvwnz2shx3d9wj9nnnnipya2q0whchyvgjqb8yzy71gq4";
      name = "qthttpserver-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtimageformats-everywhere-src-6.11.1.tar.xz";
      sha256 = "04y4pa5krrpyiqn039d6m8bzcxj6pa1m850rz3bmw5xc8ml6rgxj";
      name = "qtimageformats-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtlanguageserver-everywhere-src-6.11.1.tar.xz";
      sha256 = "1vwavpi8swgs88pfjfddnb9cmsb4k1sjcgywp2rsnm6ay8vqa02h";
      name = "qtlanguageserver-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtlocation-everywhere-src-6.11.1.tar.xz";
      sha256 = "06z4hbiqki5chhmph131s71czyrjpnjvy3rxb4560vwy55vwx49p";
      name = "qtlocation-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtlottie-everywhere-src-6.11.1.tar.xz";
      sha256 = "0y969gp64imwh49d5zbnw0wi2yva9fsp6qn58617rs9kvkdzml70";
      name = "qtlottie-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtmultimedia-everywhere-src-6.11.1.tar.xz";
      sha256 = "02lvq1jk6m67m6z0w7vdzxhzmi441j8avvp79mfclfpfvm98w3rr";
      name = "qtmultimedia-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtnetworkauth-everywhere-src-6.11.1.tar.xz";
      sha256 = "0gan2qjv97d1387jqaiis2gigm6lz5jbk1k10x13w0yc5kr5n7cz";
      name = "qtnetworkauth-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtopenapi-everywhere-src-6.11.1.tar.xz";
      sha256 = "0nzl95w5pbfd6mfb6rzv6arz09pcm6siz1n07pgm9rrdr6z083a4";
      name = "qtopenapi-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtpositioning-everywhere-src-6.11.1.tar.xz";
      sha256 = "1xbq1xjjbhb41lfp9mli8a5rgqf5pniswv0161v6wa5f04cbkrnm";
      name = "qtpositioning-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtquick3d-everywhere-src-6.11.1.tar.xz";
      sha256 = "0vs5bcz62r32gin0g4lb6wdmqrv0ypzar1s9wsza98la7zg8asy7";
      name = "qtquick3d-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtquick3dphysics-everywhere-src-6.11.1.tar.xz";
      sha256 = "1bvrmjb6m0ynq00ybdghvkbmwm237vff23ng8n4njysf05pns26i";
      name = "qtquick3dphysics-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtquickeffectmaker-everywhere-src-6.11.1.tar.xz";
      sha256 = "0sqk8hkkdibv0ayxrvpcbgj3dcwfngpd6qjp2xm15pcbx1q3xrng";
      name = "qtquickeffectmaker-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtquicktimeline-everywhere-src-6.11.1.tar.xz";
      sha256 = "09wcx83yxif8r4v81h2jfj3wlj60wnc9k4dsp7hlah4yzm1zclxg";
      name = "qtquicktimeline-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtremoteobjects-everywhere-src-6.11.1.tar.xz";
      sha256 = "06hiiyjpcgn8dp9jmgxj30nlrw73rqb869f0m63scccmqsarhqj0";
      name = "qtremoteobjects-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtscxml-everywhere-src-6.11.1.tar.xz";
      sha256 = "0gr0j09isxgii3aivfvr35x40d9n0kj0g2icc7g7bzniwm2m4jcf";
      name = "qtscxml-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtsensors-everywhere-src-6.11.1.tar.xz";
      sha256 = "13ygry3lybkgci6gkrd7k081l01icavzkiyy4g82drbvv9i70q93";
      name = "qtsensors-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtserialbus-everywhere-src-6.11.1.tar.xz";
      sha256 = "02pj4jnxc4afl5ymv7w8asggpg0hdj3dbnwwcqd305b8il69qv64";
      name = "qtserialbus-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtserialport-everywhere-src-6.11.1.tar.xz";
      sha256 = "0x1r5l3kx7riprf0b2api0bcg0z755fq9vbgmx7px6pxiy4imwws";
      name = "qtserialport-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtshadertools-everywhere-src-6.11.1.tar.xz";
      sha256 = "1z42r414jid12jmhm1yf5kw44j886w01igav0kggkg13kcphax90";
      name = "qtshadertools-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtspeech-everywhere-src-6.11.1.tar.xz";
      sha256 = "051z4yf22hkqhy3pkgxq8s77x06k4cd70i9jcmd8f99004cc6df0";
      name = "qtspeech-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtsvg-everywhere-src-6.11.1.tar.xz";
      sha256 = "154adaicyy5wyz6yc95g3lm4iw9v2zdsd7l5qp107gr490pz0g3z";
      name = "qtsvg-everywhere-src-6.11.1.tar.xz";
    };
  };
  qttasktree = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qttasktree-everywhere-src-6.11.1.tar.xz";
      sha256 = "1mjdwy3i24ggn2g82z5pg3grzhnaxmq7nmvdc7ba8dsdixzvjam2";
      name = "qttasktree-everywhere-src-6.11.1.tar.xz";
    };
  };
  qttools = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qttools-everywhere-src-6.11.1.tar.xz";
      sha256 = "03gmr9zpf0raqcvqk2cpw9lblw907hsl5cb5c2fgm4wwcxd86qcf";
      name = "qttools-everywhere-src-6.11.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qttranslations-everywhere-src-6.11.1.tar.xz";
      sha256 = "0xsnxhiqc3ybwvyn1jbhdf1sjmcf7v4mma6w9sxwg535420jrh1p";
      name = "qttranslations-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtvirtualkeyboard-everywhere-src-6.11.1.tar.xz";
      sha256 = "073y02qmpwxxdqc4pkm6k9frghsjg1zppg2hip5b4hv269xrdim1";
      name = "qtvirtualkeyboard-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtwayland-everywhere-src-6.11.1.tar.xz";
      sha256 = "1cyr5frhglp2krxvpnqk9q426rgp6nr34ngnxpa42m7p0ajqly4m";
      name = "qtwayland-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtwebchannel-everywhere-src-6.11.1.tar.xz";
      sha256 = "10ld2nh6gd1v2ssbgqlf6w0lsjlqkjdfwqv85mn5krnnf45vbyv9";
      name = "qtwebchannel-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtwebengine-everywhere-src-6.11.1.tar.xz";
      sha256 = "10vhcvw8j60n0mf38bi3fjcx5v1i0cbfyn4wbqhzqn61qv66d737";
      name = "qtwebengine-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtwebsockets-everywhere-src-6.11.1.tar.xz";
      sha256 = "1gvgci383dfm4sljqlapdiva7jhks1i2z2ayck0wbj1436hklgi4";
      name = "qtwebsockets-everywhere-src-6.11.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.11.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.1/submodules/qtwebview-everywhere-src-6.11.1.tar.xz";
      sha256 = "0g8k4xs7b0s474x00ds4i8q9b164icdgrdg8ngln10nmf3pwhqld";
      name = "qtwebview-everywhere-src-6.11.1.tar.xz";
    };
  };
}
