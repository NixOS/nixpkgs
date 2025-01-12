# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qt3d-everywhere-src-6.8.0.tar.xz";
      sha256 = "0zbv1j0i9bla73b4v15skjballff2l0lxgrdfhdkaz232ng9249s";
      name = "qt3d-everywhere-src-6.8.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qt5compat-everywhere-src-6.8.0.tar.xz";
      sha256 = "0c2yhgsn63a5m0pxchmkkqfb7izllpr46srf2pndcsqbszyhb6rw";
      name = "qt5compat-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtactiveqt-everywhere-src-6.8.0.tar.xz";
      sha256 = "0nycsn0yim01cvinfaljwmx8rllll6xw62cywqhbz61fqlsdy693";
      name = "qtactiveqt-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtbase-everywhere-src-6.8.0.tar.xz";
      sha256 = "0x9wp9fd37ycpw73s03p01zi19l93xjp57vcvrrgh9xa20blib8v";
      name = "qtbase-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtcharts-everywhere-src-6.8.0.tar.xz";
      sha256 = "0bqkbd31lxyqiw4nbwrach7hixg3q93v26di9hxb0s8s1nndl8qr";
      name = "qtcharts-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtconnectivity-everywhere-src-6.8.0.tar.xz";
      sha256 = "120pq8yvm4v72800cj0mm8069fiyan036arnc74zq1vmq1ngpgmv";
      name = "qtconnectivity-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtdatavis3d-everywhere-src-6.8.0.tar.xz";
      sha256 = "1zscaf1f4dfc5v8w8bivac5hnbq4j6j70vf78b5dcy5h2dfrdwim";
      name = "qtdatavis3d-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtdeclarative-everywhere-src-6.8.0.tar.xz";
      sha256 = "1hj4asdzkm78v0mfwyvh847j010mb43i3xx11nma66g989ms6h9v";
      name = "qtdeclarative-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtdoc-everywhere-src-6.8.0.tar.xz";
      sha256 = "0mqjki77cbm14jxxh750p6h7kixkma1nsimdl97b4lslcrs3mj1x";
      name = "qtdoc-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtgraphs-everywhere-src-6.8.0.tar.xz";
      sha256 = "0hnb1nb8bdhjkrr3b64dk9wgkdgnrb8bxdafvizy2gsr0rd4m9ab";
      name = "qtgraphs-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtgrpc-everywhere-src-6.8.0.tar.xz";
      sha256 = "0zgli0y52n5ahiahkmr1439c5vmjjv69f1x6vw4jbhc3xkp4lnvx";
      name = "qtgrpc-everywhere-src-6.8.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qthttpserver-everywhere-src-6.8.0.tar.xz";
      sha256 = "0zvrmqdch8mgpz3xbql3qy6zivyg8f0h10h86di90p1ssb40ihw1";
      name = "qthttpserver-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtimageformats-everywhere-src-6.8.0.tar.xz";
      sha256 = "1m55966458jf5n7hciahzw8fdix3d2cf1w96qzmziqcigdazhnsr";
      name = "qtimageformats-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtlanguageserver-everywhere-src-6.8.0.tar.xz";
      sha256 = "1vsw0q0pb7dbxhpg1df0bandfy7k62l68pi063fxpld4ihn1bxzv";
      name = "qtlanguageserver-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtlocation-everywhere-src-6.8.0.tar.xz";
      sha256 = "181ijzpx4xav5j282w2ppa9g5wdc4z13q0r7269flrb9ngs8gi50";
      name = "qtlocation-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtlottie-everywhere-src-6.8.0.tar.xz";
      sha256 = "15kw2cgxqh8mhip0838yalbpfnp4pd000sdalgxvc53bd8wycsfb";
      name = "qtlottie-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtmultimedia-everywhere-src-6.8.0.tar.xz";
      sha256 = "1kfgfcnihn0rqnjdif4n0hd8j2p9xkbfy3a2m3gsfypscajnlxi8";
      name = "qtmultimedia-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtnetworkauth-everywhere-src-6.8.0.tar.xz";
      sha256 = "0j6ch2p6c2b6akg0hq7iy96v118rypz77573bf4mvcy68ijmcpdr";
      name = "qtnetworkauth-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtpositioning-everywhere-src-6.8.0.tar.xz";
      sha256 = "0fgbgsg1hnwnm7bbp0j41nlpmz9g65nwj48v2c8mjiq15cz4d0gc";
      name = "qtpositioning-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtquick3d-everywhere-src-6.8.0.tar.xz";
      sha256 = "0gr2y030phghpniw7flr90f4kckiksq39y53dwddncysw970959y";
      name = "qtquick3d-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtquick3dphysics-everywhere-src-6.8.0.tar.xz";
      sha256 = "07wmy546hwavbpy368pyk0qgj79sqykqkcsnmv802qp7kwi5rcqk";
      name = "qtquick3dphysics-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtquickeffectmaker-everywhere-src-6.8.0.tar.xz";
      sha256 = "1x3lijsfd8pv74sgyjc7cj9s0c2q9bf49r44aa2d0zdjs3rxg8ca";
      name = "qtquickeffectmaker-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtquicktimeline-everywhere-src-6.8.0.tar.xz";
      sha256 = "020zv4fnx37k8nm0c462bk8r9ma7l6ivr8j7i82h6688v0ds81hi";
      name = "qtquicktimeline-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtremoteobjects-everywhere-src-6.8.0.tar.xz";
      sha256 = "123mkiak4xj05yg6sg86z1hixp8vycj0yks1fj1yk5lpdl65gpzi";
      name = "qtremoteobjects-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtscxml-everywhere-src-6.8.0.tar.xz";
      sha256 = "0fxl6yc03z43x49nskm2r1wa7vq9zg6dv1hl74nipc21yi7amadv";
      name = "qtscxml-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtsensors-everywhere-src-6.8.0.tar.xz";
      sha256 = "0yg6vn1yk4k962bff33pk9pjzyw3rskqcqfnadfvgyh5zb2l8dbj";
      name = "qtsensors-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtserialbus-everywhere-src-6.8.0.tar.xz";
      sha256 = "1ynsy0xkjdp5d3rii0ch540n8cs07dzwd66cxw59gh9j92839676";
      name = "qtserialbus-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtserialport-everywhere-src-6.8.0.tar.xz";
      sha256 = "1hz7fynpa6z0x206g920xfk45hi74fahpcyha1f09cddrwpdfrvp";
      name = "qtserialport-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtshadertools-everywhere-src-6.8.0.tar.xz";
      sha256 = "1jy4siv6ny9wgs5bcn19z05my9q8za0wi5lyngrlndw26k4jssa4";
      name = "qtshadertools-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtspeech-everywhere-src-6.8.0.tar.xz";
      sha256 = "0rb52qbwjkxlncz28rcjapi059b8px3i5haq71gm7f1pph90l8vm";
      name = "qtspeech-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtsvg-everywhere-src-6.8.0.tar.xz";
      sha256 = "16b1ckqpfhzn9xaqbwz5gy4b0xavbpjxj4064ivq23sjbqymjyng";
      name = "qtsvg-everywhere-src-6.8.0.tar.xz";
    };
  };
  qttools = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qttools-everywhere-src-6.8.0.tar.xz";
      sha256 = "1xw1k7rnm2yylbj08p9a0w2ydfcfwa50qca3dv6cc0w54vc1aca0";
      name = "qttools-everywhere-src-6.8.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qttranslations-everywhere-src-6.8.0.tar.xz";
      sha256 = "1dkw8f3hcnmnnv0ia62i5189dcgjkpx7pkcal180rka3q9kjpgw4";
      name = "qttranslations-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtvirtualkeyboard-everywhere-src-6.8.0.tar.xz";
      sha256 = "1q0cdmxm4j9w6lhm1k1ayjykknl6kmzr415qc14znr87ykbh4rcg";
      name = "qtvirtualkeyboard-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtwayland-everywhere-src-6.8.0.tar.xz";
      sha256 = "02h6lak0cp87b76474ifsm78vsx0gwfc2smnzg3g3srq2rcmhmqp";
      name = "qtwayland-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtwebchannel-everywhere-src-6.8.0.tar.xz";
      sha256 = "1h30mzmhkbcjaj4wivway0ldrdidqyg2b79313v2m3capwjhs9fn";
      name = "qtwebchannel-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtwebengine-everywhere-src-6.8.0.tar.xz";
      sha256 = "0lklgz5i3ryl6d1ghy11rvmg9isbzvrvx007nwb4qqm89294b114";
      name = "qtwebengine-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtwebsockets-everywhere-src-6.8.0.tar.xz";
      sha256 = "0vxgbqxahay0gz5cv3fl075qw3flm3hgz1srhs4jl75p8rff0jy1";
      name = "qtwebsockets-everywhere-src-6.8.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.8.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.0/submodules/qtwebview-everywhere-src-6.8.0.tar.xz";
      sha256 = "1wvrq7lf688hqvq102kyvx7kqnixxp6w25cb6rvb2xiqb50rvf3w";
      name = "qtwebview-everywhere-src-6.8.0.tar.xz";
    };
  };
}
