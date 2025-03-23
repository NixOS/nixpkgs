# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qt3d-everywhere-src-6.8.2.tar.xz";
      sha256 = "0i4cgcvhngq716009r4yjn1ma67vpr4cj2ks13yxba4iy1966yjp";
      name = "qt3d-everywhere-src-6.8.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qt5compat-everywhere-src-6.8.2.tar.xz";
      sha256 = "05jk959ykc96gp1chszr5pmv916nzd8g5gk6qbfy427cjny58cdm";
      name = "qt5compat-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtactiveqt-everywhere-src-6.8.2.tar.xz";
      sha256 = "09dr5jr1qavy9795jzrf9my9ffcwf4n4arkjb5jkk1m1274nvhil";
      name = "qtactiveqt-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtbase-everywhere-src-6.8.2.tar.xz";
      sha256 = "01gy1p8zvxq8771x6iqkrc7s3kzdddgf1i7xj656w7j1dp746801";
      name = "qtbase-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtcharts-everywhere-src-6.8.2.tar.xz";
      sha256 = "0py56kxmp766jp4vxxn91nclhg7sjgwzc3b1xa62yysx3bd88z7c";
      name = "qtcharts-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtconnectivity-everywhere-src-6.8.2.tar.xz";
      sha256 = "0al1a86q0cd1xrs1f7wsk3cjq74yvrvw3wk4c3ynkhsa107145z6";
      name = "qtconnectivity-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtdatavis3d-everywhere-src-6.8.2.tar.xz";
      sha256 = "09hyqnaqsc0li5sp8s9y3r945pmz1y9a8r4q5hy9hvszmx0r58nd";
      name = "qtdatavis3d-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtdeclarative-everywhere-src-6.8.2.tar.xz";
      sha256 = "0mkd6hqvg21dg63022iq1b6sskp2s5wfchsifc4mkdcbvim8fk8l";
      name = "qtdeclarative-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtdoc-everywhere-src-6.8.2.tar.xz";
      sha256 = "1iaxangaskc8v0mwqxn27pq1k4wjlq6d2ixja8qfsl69ql25pkmk";
      name = "qtdoc-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtgraphs-everywhere-src-6.8.2.tar.xz";
      sha256 = "1m267jp6xns7aipxkk13s2k64h33mfslp5h5j1zgsvrg92is9iq5";
      name = "qtgraphs-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtgrpc-everywhere-src-6.8.2.tar.xz";
      sha256 = "1nrnd6y5ip1yv6k15qq183ghcgacfdfhngk03jm2840qv86z2rcc";
      name = "qtgrpc-everywhere-src-6.8.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qthttpserver-everywhere-src-6.8.2.tar.xz";
      sha256 = "14h6j3cf36lylb01drpbzmbm7nyq4vgc3bgp64436nws0k0ig59d";
      name = "qthttpserver-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtimageformats-everywhere-src-6.8.2.tar.xz";
      sha256 = "1qf88gjff2bdb51ijdpjzf1l7w00prqb29wjqapa1f078ywbp8fj";
      name = "qtimageformats-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtlanguageserver-everywhere-src-6.8.2.tar.xz";
      sha256 = "1yw54x6g291z88ib7g0ydz9y5940vr71xh28fmvhhk1k2nn79swy";
      name = "qtlanguageserver-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtlocation-everywhere-src-6.8.2.tar.xz";
      sha256 = "068pgnds6hgmj6lmxwlapc9nx69cz2bzndgksvm051kb875hnjck";
      name = "qtlocation-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtlottie-everywhere-src-6.8.2.tar.xz";
      sha256 = "085yiqihp54m94nw2r82dfnjpf5kvr43bywhr02xv4q31nr3xm2y";
      name = "qtlottie-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtmultimedia-everywhere-src-6.8.2.tar.xz";
      sha256 = "0s8mxd7pwm9v8x5qa3h6124w91k0zjbbah6h9b68n5bvq3yn3x9l";
      name = "qtmultimedia-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtnetworkauth-everywhere-src-6.8.2.tar.xz";
      sha256 = "1mxlam2fzh8arfq7iypsvlk4h2pbj41f5a7ibakap1zc4ysv95fl";
      name = "qtnetworkauth-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtpositioning-everywhere-src-6.8.2.tar.xz";
      sha256 = "1rdqbp4yxzyd3c77bf4y9klvbvv1pimg4zqmw6kncr4k9r7ncc6z";
      name = "qtpositioning-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtquick3d-everywhere-src-6.8.2.tar.xz";
      sha256 = "0v8bkx51b6lhaknrdsfj1k127vccn24snmkpzfxcdcf5p36fnk08";
      name = "qtquick3d-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtquick3dphysics-everywhere-src-6.8.2.tar.xz";
      sha256 = "0gvrp9060k6d7jmjj0hialhigpv0c0c42szijsbs56bn98njc66z";
      name = "qtquick3dphysics-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtquickeffectmaker-everywhere-src-6.8.2.tar.xz";
      sha256 = "0z301rr7svga92ncbfdfsjpmxq85n6vd92s3vkgica0pjdc3rksg";
      name = "qtquickeffectmaker-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtquicktimeline-everywhere-src-6.8.2.tar.xz";
      sha256 = "1ahspk05h676j8vlf2kgpc25mb9bc3p8m9iicxzkvfzsv7pbqgf3";
      name = "qtquicktimeline-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtremoteobjects-everywhere-src-6.8.2.tar.xz";
      sha256 = "0adnbqdppawy4k8j5d87h59v9mdfhdrj4yfbhy0vy2qvw7nx6anh";
      name = "qtremoteobjects-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtscxml-everywhere-src-6.8.2.tar.xz";
      sha256 = "14x1iv7wdaifly06dh5w0iqa46va0hikg1c4rh0yj0a0l88llg38";
      name = "qtscxml-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtsensors-everywhere-src-6.8.2.tar.xz";
      sha256 = "1jplvcnpp7xc8d1lpw7qzrk6pvm8lrn84r2hy7dspl0s02dpr0ca";
      name = "qtsensors-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtserialbus-everywhere-src-6.8.2.tar.xz";
      sha256 = "04m1p69rbsjhngnlpdf60k0y7zyjrqvrg732vdzmhdfrsaxdc68r";
      name = "qtserialbus-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtserialport-everywhere-src-6.8.2.tar.xz";
      sha256 = "1rrv3snfc5r08q5dx37vrns1vwk6rnw1l0ldym4z32g9c4iy05zd";
      name = "qtserialport-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtshadertools-everywhere-src-6.8.2.tar.xz";
      sha256 = "0w8qamghycprmz20n01s0di8as52v7j4qnn57bb71z45i07gkmfi";
      name = "qtshadertools-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtspeech-everywhere-src-6.8.2.tar.xz";
      sha256 = "1hq2y8dwr57gcqq1zj3w42ykwmzphjh2yf1ab3s9005rdcrm56z0";
      name = "qtspeech-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtsvg-everywhere-src-6.8.2.tar.xz";
      sha256 = "1yn1kl5cvpnl7619r1inbmik4yg0cy87xn1irz5ijvd63kr7j9da";
      name = "qtsvg-everywhere-src-6.8.2.tar.xz";
    };
  };
  qttools = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qttools-everywhere-src-6.8.2.tar.xz";
      sha256 = "1h6jacmzyb4qrsmk68if72avsydfk31ap4gj28v921rzsjvq2qrj";
      name = "qttools-everywhere-src-6.8.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qttranslations-everywhere-src-6.8.2.tar.xz";
      sha256 = "1ld3sv309shkm267ab0f5f849lw8j8ll062c5iq7gz8bb256w46j";
      name = "qttranslations-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtvirtualkeyboard-everywhere-src-6.8.2.tar.xz";
      sha256 = "09ybfxi9fpmv7jjvqmkbg432l5ymp6my23bvr42dmdbqd4aybp1d";
      name = "qtvirtualkeyboard-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtwayland-everywhere-src-6.8.2.tar.xz";
      sha256 = "0iwnvjas5vqzi48finff72iqnl5hal48qba64kwjnpr911wiaijy";
      name = "qtwayland-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtwebchannel-everywhere-src-6.8.2.tar.xz";
      sha256 = "1b5pd0f3zbz4q6cygjn8fbrsbfb7rlwi4nq0f1vaaws6yi9ix7w6";
      name = "qtwebchannel-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtwebengine-everywhere-src-6.8.2.tar.xz";
      sha256 = "00j8wlz6fbg4ivkc6w7dbc67835hv7w74sfrshdb75y12rzri5gz";
      name = "qtwebengine-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtwebsockets-everywhere-src-6.8.2.tar.xz";
      sha256 = "1glczsi3pgrhgb6v20pqm8invnfjb8415lcj74wwhiilp9igb7ci";
      name = "qtwebsockets-everywhere-src-6.8.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.8.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.2/submodules/qtwebview-everywhere-src-6.8.2.tar.xz";
      sha256 = "0hyhpr3ai77pwdc69q73r1wkibdn2vn6v1pqkc8minck24kkdd46";
      name = "qtwebview-everywhere-src-6.8.2.tar.xz";
    };
  };
}
