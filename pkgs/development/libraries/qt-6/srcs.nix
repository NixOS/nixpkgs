# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/fetch.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qt3d-everywhere-src-6.6.2.tar.xz";
      sha256 = "10l5ldw8g8m1ig3hh78pwg749xqf2gw9vsi8p67gbkanmipfqx4i";
      name = "qt3d-everywhere-src-6.6.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qt5compat-everywhere-src-6.6.2.tar.xz";
      sha256 = "0rqr34lqf4mjdgjj09wzlvkxfknz8arjl9p30xpqbr2qfsmhhyz0";
      name = "qt5compat-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtactiveqt-everywhere-src-6.6.2.tar.xz";
      sha256 = "16vqb33s0dwxq1rrha81606fdwq1dz7az6mybgx18n7f081h3yl7";
      name = "qtactiveqt-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz";
      sha256 = "0yv78bwqzy975854h53rbiilsms62f3v02i3jqz7v8ajk1ml56xq";
      name = "qtbase-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtcharts-everywhere-src-6.6.2.tar.xz";
      sha256 = "1x7m87lxbza4ynf6dq7yshann6003302a5fxih5l5d07xri64j5i";
      name = "qtcharts-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtconnectivity-everywhere-src-6.6.2.tar.xz";
      sha256 = "1dzsvs0hngrz6b66r9zb4al5a4r6xxfd29i8g3jqmvw3b0452vx3";
      name = "qtconnectivity-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtdatavis3d-everywhere-src-6.6.2.tar.xz";
      sha256 = "0iqw5afx8y29kjprn1hlz0zr0qwc9j0m7my75qf1av800hlnnjii";
      name = "qtdatavis3d-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtdeclarative-everywhere-src-6.6.2.tar.xz";
      sha256 = "0k6qndjvkkx3g8lr7f64xx86b3cwxzkgpl6fr6cp73s6qjkyk763";
      name = "qtdeclarative-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtdoc-everywhere-src-6.6.2.tar.xz";
      sha256 = "0hvv40y2h7xa7wj2cqz2rrsvy1xf2l95199vmgx4q27wgmn1xixg";
      name = "qtdoc-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtgraphs-everywhere-src-6.6.2.tar.xz";
      sha256 = "19j9hdpxrclsdwqqblp4bk94zd2a5rvxnf548hm7r03npznjvb26";
      name = "qtgraphs-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtgrpc-everywhere-src-6.6.2.tar.xz";
      sha256 = "1flfm8j5vw2j6xzms1b470mbqyab1nrnj4z9s4mgwnbsp4m5p85w";
      name = "qtgrpc-everywhere-src-6.6.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qthttpserver-everywhere-src-6.6.2.tar.xz";
      sha256 = "1qzw96y20qr1kc9wmys61wm568jsknvlgvh09bbqjcmm6dm3lhd2";
      name = "qthttpserver-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtimageformats-everywhere-src-6.6.2.tar.xz";
      sha256 = "1cvwm0hnspglydms6qhcp5g0ayz5pamigl52kz8km66l6s8lqn3i";
      name = "qtimageformats-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtlanguageserver-everywhere-src-6.6.2.tar.xz";
      sha256 = "1bgazi44mwac20biybhp21icgwa8k7jd295j8jsfgzxbw12lq7y3";
      name = "qtlanguageserver-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtlocation-everywhere-src-6.6.2.tar.xz";
      sha256 = "05glwmasg0rlhybzpb640iibcs6gyrqbs7h1ws4b5vgcmzzdq9cy";
      name = "qtlocation-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtlottie-everywhere-src-6.6.2.tar.xz";
      sha256 = "1hqhp55jfasavk7p8xb0srbc6lnk70w2q0x4iwn28z5s5kd1cvi7";
      name = "qtlottie-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtmultimedia-everywhere-src-6.6.2.tar.xz";
      sha256 = "1v0430jnv97ws6cizn9mi8zr9hcg7rixd0jg7smhdq8apacjb572";
      name = "qtmultimedia-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtnetworkauth-everywhere-src-6.6.2.tar.xz";
      sha256 = "1lijsdwbj8gscfllmp358n5ysa8pvhx2msh7gpxvb4x81daxbg9j";
      name = "qtnetworkauth-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtpositioning-everywhere-src-6.6.2.tar.xz";
      sha256 = "1qn31vps9dj4g8m7d195qlsyj3p4dfqqszdc6yqq097dq5y5d9sd";
      name = "qtpositioning-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtquick3d-everywhere-src-6.6.2.tar.xz";
      sha256 = "0f1sp7d1jzdzaxqs2l2yjprp0axcqbg2w82dza7wl4paan4rzp7w";
      name = "qtquick3d-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtquick3dphysics-everywhere-src-6.6.2.tar.xz";
      sha256 = "10209x9hbr5bc4vlhhcvvfsmsn2h3dyb4rlg0f0gpllx68mr58ac";
      name = "qtquick3dphysics-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtquickeffectmaker-everywhere-src-6.6.2.tar.xz";
      sha256 = "0lywm71wp943dk3w8zkklyxfk97w48v670zs6pc4pj4ja0ns37q7";
      name = "qtquickeffectmaker-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtquicktimeline-everywhere-src-6.6.2.tar.xz";
      sha256 = "06cr9p0hrq77ckqslxh0h3lpyw31fblyap1plcyyj8ssr1rm4klc";
      name = "qtquicktimeline-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtremoteobjects-everywhere-src-6.6.2.tar.xz";
      sha256 = "0fbkjzykxpkz8myr6dy588gcmhyy3lar17v78zfam8kyxq7s5qxa";
      name = "qtremoteobjects-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtscxml-everywhere-src-6.6.2.tar.xz";
      sha256 = "0gm4805570ds3jmkbwrjigbg93zc561bd5rc52r71042zzq84j89";
      name = "qtscxml-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtsensors-everywhere-src-6.6.2.tar.xz";
      sha256 = "0a3w50bfnmxndyxnn9lsy1wxffhm2am0yjxqx3vx0gfjwv79yvsa";
      name = "qtsensors-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtserialbus-everywhere-src-6.6.2.tar.xz";
      sha256 = "0g7sx81lrb5r2ipinnghq4iss6clkwbzjb0ck4ay6hmpw54smzww";
      name = "qtserialbus-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtserialport-everywhere-src-6.6.2.tar.xz";
      sha256 = "16j5fprmdzzc1snnj5184ihq5avg1s0jrqqcjk70dvmimsf0q7ms";
      name = "qtserialport-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtshadertools-everywhere-src-6.6.2.tar.xz";
      sha256 = "0bxrczs9nw6az2p4n8x0f660vsmxxynx4iqgj75l4zsfzzbym2v2";
      name = "qtshadertools-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtspeech-everywhere-src-6.6.2.tar.xz";
      sha256 = "1qvf3p2p1pc5fw40d8zq0iawaaqkc0dp5yx85b1dnw1j809bn8y0";
      name = "qtspeech-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtsvg-everywhere-src-6.6.2.tar.xz";
      sha256 = "10c1dmbv5d39n1q4m67gf2h4n6wfkzrlyk8plnxbyhhvxxcis8ss";
      name = "qtsvg-everywhere-src-6.6.2.tar.xz";
    };
  };
  qttools = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qttools-everywhere-src-6.6.2.tar.xz";
      sha256 = "0ij7djy06xi4v5v29fh31gqq5rnc12vviv3qg3vqf4hiaagrxm76";
      name = "qttools-everywhere-src-6.6.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qttranslations-everywhere-src-6.6.2.tar.xz";
      sha256 = "0xqcad8aa9lp6wzh1rs46id6r60zdw82qj3bq9k2b89sxy8c0fna";
      name = "qttranslations-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtvirtualkeyboard-everywhere-src-6.6.2.tar.xz";
      sha256 = "07nqds49g2x748jsk17cnd2ph81165xnzn70jwxd0gpbi3dzshk1";
      name = "qtvirtualkeyboard-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtwayland-everywhere-src-6.6.2.tar.xz";
      sha256 = "0y6x84ckcc53ddclnrlzs08b1kvw6saw9nim0hz4wc5fyz7dbkcv";
      name = "qtwayland-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtwebchannel-everywhere-src-6.6.2.tar.xz";
      sha256 = "1incvisc3j758b4k82vnwci8j1bba8zf6xgmgcrsm553k4wpsz1x";
      name = "qtwebchannel-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtwebengine-everywhere-src-6.6.2.tar.xz";
      sha256 = "15h3hniszfkxv2vnn3fnbgbar8wb41ypgn4b4iz4iy6csar8f7fn";
      name = "qtwebengine-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtwebsockets-everywhere-src-6.6.2.tar.xz";
      sha256 = "1y9q8jmspxbfxf07jdcg4n8zwmchccyzp0z68fxr0hnvr2dymrn0";
      name = "qtwebsockets-everywhere-src-6.6.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.6.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.2/submodules/qtwebview-everywhere-src-6.6.2.tar.xz";
      sha256 = "0z3p1g26yg3dr3hhavwd5wz9b8yi838xj4s57068wykd80v145wb";
      name = "qtwebview-everywhere-src-6.6.2.tar.xz";
    };
  };
}
