# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qt3d-everywhere-src-6.3.2.tar.xz";
      sha256 = "0gy73dlzj0hajxr0v68sljqvqclcryirm901icszg1mfvl4xw6zj";
      name = "qt3d-everywhere-src-6.3.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qt5compat-everywhere-src-6.3.2.tar.xz";
      sha256 = "1k30hnwnlbay1hnkdavgf6plsdzrryzcqd2qz8x11r477w7sr8wi";
      name = "qt5compat-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtactiveqt-everywhere-src-6.3.2.tar.xz";
      sha256 = "052mcwln989hp154kdrjxmif81glx4x3qcmnhss4n1ps4m28jw7w";
      name = "qtactiveqt-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtbase-everywhere-src-6.3.2.tar.xz";
      sha256 = "19m9r8sf9mvyrwipn44if3nhding4ljys2mwf04b7dkhz16vlabr";
      name = "qtbase-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtcharts-everywhere-src-6.3.2.tar.xz";
      sha256 = "1xpv7vijamm1iwx71wbyc7wqw9s35j1iz1ycp5c1a33hhq9lxa5a";
      name = "qtcharts-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtconnectivity-everywhere-src-6.3.2.tar.xz";
      sha256 = "0n56z6vdf4pc4jqrimsl6gd30vgac2sirz7z2v29d71ca1n6ajg2";
      name = "qtconnectivity-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtdatavis3d-everywhere-src-6.3.2.tar.xz";
      sha256 = "13xg4vs3wm47f3wbh56qnrd3wa130g0z4jhf494zd7y2n5vi4r7z";
      name = "qtdatavis3d-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtdeclarative-everywhere-src-6.3.2.tar.xz";
      sha256 = "1hbw63828pp8vm9b46i2pkcbcpr4mq9nblhmpwrw2pflq0fi24xq";
      name = "qtdeclarative-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtdoc-everywhere-src-6.3.2.tar.xz";
      sha256 = "001mf5vrgjz0hbi90qcp66lbs5hv3iickfv6780j2nsc94wjc5mp";
      name = "qtdoc-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtimageformats-everywhere-src-6.3.2.tar.xz";
      sha256 = "0fnfhlvd12v1gk81x5zhhrkmn6k80n3zfw5in0yrqxvcmr68mjqx";
      name = "qtimageformats-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtlanguageserver-everywhere-src-6.3.2.tar.xz";
      sha256 = "00ya6lqwv2dq2g86c53aafisp5vnkgamylslg5fqd8ym29g6wraj";
      name = "qtlanguageserver-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtlottie-everywhere-src-6.3.2.tar.xz";
      sha256 = "1c092hmf114r8jfdhkhxnn3vywj93mg33whzav47gr9mbza44icq";
      name = "qtlottie-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtmultimedia-everywhere-src-6.3.2.tar.xz";
      sha256 = "0hqwq0ad6z8c5kyyvbaddj00mciijn2ns2r60jc3mqh98nm2js3z";
      name = "qtmultimedia-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtnetworkauth-everywhere-src-6.3.2.tar.xz";
      sha256 = "0mjnz87splyxq7jwydi5ws2aqb6j7czscrkns193w425x0dgy94l";
      name = "qtnetworkauth-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtpositioning-everywhere-src-6.3.2.tar.xz";
      sha256 = "0zh45lf164nzwl1hh96qm64nyw9wzzrnm5s7sx761glz54q6l5xz";
      name = "qtpositioning-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtquick3d-everywhere-src-6.3.2.tar.xz";
      sha256 = "00wwla3crql4wwbaz116icgc4liszi497g692z8fxllvp4ysm80x";
      name = "qtquick3d-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtquicktimeline-everywhere-src-6.3.2.tar.xz";
      sha256 = "0njidyr7ahvrq1x1676v16qcp7lz2v2rhz0x3iw2mql90vrhk2h4";
      name = "qtquicktimeline-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtremoteobjects-everywhere-src-6.3.2.tar.xz";
      sha256 = "099b3vchi458i4fci9kfwan871jplqlk5l8q78mfnh33g80qnasi";
      name = "qtremoteobjects-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtscxml-everywhere-src-6.3.2.tar.xz";
      sha256 = "1h90kiin6n4629nlzqkilhvn30q4ppr9kwbcxbsck4zss91yc6n5";
      name = "qtscxml-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtsensors-everywhere-src-6.3.2.tar.xz";
      sha256 = "1r82rpn552737n04b0wvv8g9rzqxvsr1snd22bwfb4djjn5b47j5";
      name = "qtsensors-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtserialbus-everywhere-src-6.3.2.tar.xz";
      sha256 = "04j5q2lwvbzp977zayj48ixwg4mkq0x58fk88l4kfkgy1xmrwgnh";
      name = "qtserialbus-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtserialport-everywhere-src-6.3.2.tar.xz";
      sha256 = "0vsyqdibf8mn4481vb6sc4chgabbqzcxw1mxxm3kdik74cr0gln7";
      name = "qtserialport-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtshadertools-everywhere-src-6.3.2.tar.xz";
      sha256 = "1bmkrpk414clx8pnyrdslqlsnfmsdldmwrdcqzz6rwi8ymk2ggpn";
      name = "qtshadertools-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtsvg-everywhere-src-6.3.2.tar.xz";
      sha256 = "14i3f23k9k0731akpwa6zzhw5m3c0m2l5r7irvim4h4faah445ac";
      name = "qtsvg-everywhere-src-6.3.2.tar.xz";
    };
  };
  qttools = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qttools-everywhere-src-6.3.2.tar.xz";
      sha256 = "1lmfk5bhgg4daxkqrhmx4iyln7pyiz40c9cp6plyp35nz8ppvc75";
      name = "qttools-everywhere-src-6.3.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qttranslations-everywhere-src-6.3.2.tar.xz";
      sha256 = "1h66n9cx4g65c9wrgp32h9gm3r47gyh1nrcn3ivbfbvngfawqxpg";
      name = "qttranslations-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtvirtualkeyboard-everywhere-src-6.3.2.tar.xz";
      sha256 = "0czxh6wc1qgxns1qm6zcnck6i0nzaz3bzi3725qdw98738lyhvml";
      name = "qtvirtualkeyboard-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtwayland-everywhere-src-6.3.2.tar.xz";
      sha256 = "0rwiirkibgpvx05pg2842j4dcq9ckxmcqxhaf50xx2i55z64ll83";
      name = "qtwayland-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtwebchannel-everywhere-src-6.3.2.tar.xz";
      sha256 = "0gqm09yqdq27kgb02idx5ycj14k5mjhh10ddp9jfs8lblimlgfni";
      name = "qtwebchannel-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtwebengine-everywhere-src-6.3.2.tar.xz";
      sha256 = "09j4w9ax8242d1yx3hmic7jcwidwdrn8sp7k89hj4l0n8mzkkd35";
      name = "qtwebengine-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtwebsockets-everywhere-src-6.3.2.tar.xz";
      sha256 = "1smbvidaybphvsmaap9v1pbkibwmng11hb925g0ww4ghwzpxkb8q";
      name = "qtwebsockets-everywhere-src-6.3.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.3.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.2/submodules/qtwebview-everywhere-src-6.3.2.tar.xz";
      sha256 = "06v69xl0fnbv4i1xbjaw7338iqyvim8d3q91qrrg7r2nqzjhiav7";
      name = "qtwebview-everywhere-src-6.3.2.tar.xz";
    };
  };
}
