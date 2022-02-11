# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.12
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qt3d-everywhere-src-5.12.10.tar.xz";
      sha256 = "1fnhdy0vwh1npq04pw3lzb15rsp0nx8wh57c8lvz9jn945xwc3vd";
      name = "qt3d-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtactiveqt-everywhere-src-5.12.10.tar.xz";
      sha256 = "0lf96ziba5g8izwcjzzaf4n2j336j6627rb3dzwvmsdkd9168zax";
      name = "qtactiveqt-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtandroidextras-everywhere-src-5.12.10.tar.xz";
      sha256 = "0blapv4jd80wcvzp96zxlrsyca7lwax17y6yij1d14a51353hrnc";
      name = "qtandroidextras-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtbase = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtbase-everywhere-src-5.12.10.tar.xz";
      sha256 = "0h39r3irahdms4gidg5l4a1kr7kagc4bd0y02sapg3njwrsg3240";
      name = "qtbase-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtcanvas3d-everywhere-src-5.12.10.tar.xz";
      sha256 = "0pbxw89m2s19yk2985c49msd7s1mapydka9b7nzg9phs9nrzvf1m";
      name = "qtcanvas3d-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtcharts = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtcharts-everywhere-src-5.12.10.tar.xz";
      sha256 = "0cndm8llvfl9jdzn34b886gxgxwsibb24amhblh96cadhhkpwadc";
      name = "qtcharts-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtconnectivity-everywhere-src-5.12.10.tar.xz";
      sha256 = "19l816zfpx87vwzj18mbib5x3mb9hy1msacpy8i9bagfw9p0i6c0";
      name = "qtconnectivity-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtdatavis3d-everywhere-src-5.12.10.tar.xz";
      sha256 = "1ximhph17kkh40v2ksk51lq21mbjs2ajyf5l32ckhc7n7bmaryb6";
      name = "qtdatavis3d-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtdeclarative-everywhere-src-5.12.10.tar.xz";
      sha256 = "05la1zlijcaargfh4ljnmxvvksdwzl409wl7w3m96kwm8s370mmf";
      name = "qtdeclarative-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtdoc = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtdoc-everywhere-src-5.12.10.tar.xz";
      sha256 = "0ljc29hnn8knncvq8hsk0rdcwrxbsk1ywlprknkvyb4pggp9rkp6";
      name = "qtdoc-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtgamepad-everywhere-src-5.12.10.tar.xz";
      sha256 = "1bs50wghy3n8af656angkkkaac0swkq3mfllg3dkjg236ngzdhdh";
      name = "qtgamepad-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtgraphicaleffects-everywhere-src-5.12.10.tar.xz";
      sha256 = "0hnsb757ircqmid34d0cxbh0mi4qnil22k5ka9a1b8xy00ydkfky";
      name = "qtgraphicaleffects-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtimageformats-everywhere-src-5.12.10.tar.xz";
      sha256 = "1bh38xp4v914ksg91p9pij1gsdzs3y7sn7diy3d7wn5i039syn0i";
      name = "qtimageformats-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtlocation = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtlocation-everywhere-src-5.12.10.tar.xz";
      sha256 = "1czg0z69ilnxp1sqk0jawlnyp2gx87yb57g8dwjznqxxvaq744dc";
      name = "qtlocation-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtmacextras-everywhere-src-5.12.10.tar.xz";
      sha256 = "0mh9p3f1f22pj4i8yxnn56amy53dapmcikza04ll4fvx5hy340v8";
      name = "qtmacextras-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtmultimedia-everywhere-src-5.12.10.tar.xz";
      sha256 = "0g50jzhwbrl5r0lmfz5ffpkp54mf0zfc8m884x51yn2bnngg366c";
      name = "qtmultimedia-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtnetworkauth-everywhere-src-5.12.10.tar.xz";
      sha256 = "12n3xqlskrk2mbcgz5p613sx219j6rmpq8yn7p97xdv7li61gzl2";
      name = "qtnetworkauth-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtpurchasing-everywhere-src-5.12.10.tar.xz";
      sha256 = "1azdg03vxyk140i9z93x0zzlazbmd3qrqxgwk747jsd1ibns9ddy";
      name = "qtpurchasing-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtquickcontrols-everywhere-src-5.12.10.tar.xz";
      sha256 = "1cy9vjl9zf95frnydzljqwbx3is8p8w27kdgszvmb67p6xkpblk7";
      name = "qtquickcontrols-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtquickcontrols2-everywhere-src-5.12.10.tar.xz";
      sha256 = "0541n8n012d0xwxrfznv1jwh28d35mdx6cl8jadsaxaspgwz4vb3";
      name = "qtquickcontrols2-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtremoteobjects-everywhere-src-5.12.10.tar.xz";
      sha256 = "147p0xdi22xz2d3501ig78bs97gbyz8ccyhn6dhbw2yalx33gma6";
      name = "qtremoteobjects-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtscript = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtscript-everywhere-src-5.12.10.tar.xz";
      sha256 = "1cfcfwq4shr6yphgwq2jnvgzjjqjrz10qnzr7dccksmfg3i0ad02";
      name = "qtscript-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtscxml = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtscxml-everywhere-src-5.12.10.tar.xz";
      sha256 = "057zchhm1s5ly2a685y4105pgmzgqp1jkkf9w0ca8xd05z4clb4r";
      name = "qtscxml-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtsensors = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtsensors-everywhere-src-5.12.10.tar.xz";
      sha256 = "10f00njvc7kwjci0g4g3pibl9ra798iplvj2ymql3zppxqqdq25m";
      name = "qtsensors-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtserialbus-everywhere-src-5.12.10.tar.xz";
      sha256 = "0zd0crs2nrsvncj070fl05g0nm3j5bf16g54c7m9603b6q7bryrx";
      name = "qtserialbus-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtserialport = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtserialport-everywhere-src-5.12.10.tar.xz";
      sha256 = "0anndf6pyssiygj0kk2j80vwil2z0765gccs87djhsni1xvk3n9r";
      name = "qtserialport-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtspeech = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtspeech-everywhere-src-5.12.10.tar.xz";
      sha256 = "11fycm604r1xswb9dg1g568jxd68zd9m2dzfy4qda6sr4mdaj6jg";
      name = "qtspeech-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtsvg = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtsvg-everywhere-src-5.12.10.tar.xz";
      sha256 = "0jrkz8y225g93pznsvc1icanxxc5cfm23ic2y6rprqaqw77z9zxm";
      name = "qtsvg-everywhere-src-5.12.10.tar.xz";
    };
  };
  qttools = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qttools-everywhere-src-5.12.10.tar.xz";
      sha256 = "0v339a1w3kqvfl8hcds032g8zafp8d4c1b2rzihpq6y4mbksdkxh";
      name = "qttools-everywhere-src-5.12.10.tar.xz";
    };
  };
  qttranslations = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qttranslations-everywhere-src-5.12.10.tar.xz";
      sha256 = "1pjkkkkjvs9harz70sir67yf3i528vyn1shmi09hlzlb23nmipp1";
      name = "qttranslations-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtvirtualkeyboard-everywhere-src-5.12.10.tar.xz";
      sha256 = "0afw3lj5cg3zj0hzxlhz5l7s1j2y491yxwylc4vchbqjpyvsadgg";
      name = "qtvirtualkeyboard-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwayland = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwayland-everywhere-src-5.12.10.tar.xz";
      sha256 = "1bs61xmc4l03w21wkrxx0llfg5bbnq5ij7w0bnfkx3rk0vncy0q6";
      name = "qtwayland-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwebchannel-everywhere-src-5.12.10.tar.xz";
      sha256 = "1jmprqgavqwknnnl6qp0psxz7bc69ivxhm7y4qci95vpx9k5yjg8";
      name = "qtwebchannel-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwebengine-everywhere-src-5.12.10.tar.xz";
      sha256 = "16zbyfc7qy9f20anfrdi25f6nf1j7zw8kps60mqb18nfjw411d50";
      name = "qtwebengine-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwebglplugin-everywhere-src-5.12.10.tar.xz";
      sha256 = "0nhim67rl9dbshnarismnd54qzks8v14a08h8qi7x0dm9bj9ij7q";
      name = "qtwebglplugin-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwebsockets-everywhere-src-5.12.10.tar.xz";
      sha256 = "0p74ds53d3a30i7pq85b9ql9i4z1p0yyanhmaizw2bv9225py4jr";
      name = "qtwebsockets-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwebview = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwebview-everywhere-src-5.12.10.tar.xz";
      sha256 = "07pz7wfhyijfdlxnaqpn4hwgvpglma6dfmkcb8xw6hfhg30riaxd";
      name = "qtwebview-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtwinextras-everywhere-src-5.12.10.tar.xz";
      sha256 = "1x5k0z0p94zppqsw2fz8ki9v5abf0crzva16wllznn89ylqjyn0j";
      name = "qtwinextras-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtx11extras-everywhere-src-5.12.10.tar.xz";
      sha256 = "0xk10iynkfs31vgpadrmw30k4s1hlnggxy2f3q988qyqd37dh5h8";
      name = "qtx11extras-everywhere-src-5.12.10.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.12.10";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.12/5.12.10/submodules/qtxmlpatterns-everywhere-src-5.12.10.tar.xz";
      sha256 = "1qg09yxagz36sry03kv3swwfjc8lrik1asjk2lxlpzzcl2q95lbv";
      name = "qtxmlpatterns-everywhere-src-5.12.10.tar.xz";
    };
  };
}
