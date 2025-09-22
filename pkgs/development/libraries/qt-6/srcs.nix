# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qt3d-everywhere-src-6.9.2.tar.xz";
      sha256 = "0ndn5fbsfj2vbcq3siq1gnk2rgblicd6ri2jrh9g41anicxh4vma";
      name = "qt3d-everywhere-src-6.9.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qt5compat-everywhere-src-6.9.2.tar.xz";
      sha256 = "0q2vly836wgs462czw7lg0ysf2h48iwbdy43wwf2gz49qq2rja6b";
      name = "qt5compat-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtactiveqt-everywhere-src-6.9.2.tar.xz";
      sha256 = "003vgfxswi6cpdp9i8kdzm1n34cbrbzlap4sg9h1ap0i9is51s1w";
      name = "qtactiveqt-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtbase-everywhere-src-6.9.2.tar.xz";
      sha256 = "0h149x8l2ywfr5m034n20z6cjxnldary39x0vv22jhg0ryg9rgj4";
      name = "qtbase-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtcharts-everywhere-src-6.9.2.tar.xz";
      sha256 = "0jzzlh0jq5fidgs9r4aqpilyj0nan30r1d0pigp1hgz7cigz20cz";
      name = "qtcharts-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtconnectivity-everywhere-src-6.9.2.tar.xz";
      sha256 = "0qq4d8hn6s8bb9r2gglb6gzq6isbb13knqh7n2s2wsnx8rqwdzwa";
      name = "qtconnectivity-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtdatavis3d-everywhere-src-6.9.2.tar.xz";
      sha256 = "0p6bvia085hx3jb1la06c2q48m9i897r1a1mf6bi2hbmm2hirzsx";
      name = "qtdatavis3d-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtdeclarative-everywhere-src-6.9.2.tar.xz";
      sha256 = "0r16qima008y2999r1djvwry01l295nmwwhqg081d2fr1cn2szs7";
      name = "qtdeclarative-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtdoc-everywhere-src-6.9.2.tar.xz";
      sha256 = "0qng2lsqmrrj8n85aqh8vl4nlzc23va9hynvvf6gqr35anvbpniz";
      name = "qtdoc-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtgraphs-everywhere-src-6.9.2.tar.xz";
      sha256 = "0wsa4iar52dhiilyl053j7lmsw3xdn47b0pjrylb5a0ij1izp057";
      name = "qtgraphs-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtgrpc-everywhere-src-6.9.2.tar.xz";
      sha256 = "0r1z6lbjcsgxhvzylpr8z8wl44ql14ajf99n1hfvf4gy4f43qgd4";
      name = "qtgrpc-everywhere-src-6.9.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qthttpserver-everywhere-src-6.9.2.tar.xz";
      sha256 = "06a0f7j1b309xffw3rwydz8lpzxnf5jg67savswskzbd3lfzlhqk";
      name = "qthttpserver-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtimageformats-everywhere-src-6.9.2.tar.xz";
      sha256 = "0fciahs4i0nn5z0j624gkfncqg6byxswj45bw81drpjp5xz3y0la";
      name = "qtimageformats-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtlanguageserver-everywhere-src-6.9.2.tar.xz";
      sha256 = "1vlb0qn53y1b4zf7zkpxdvdh5ikr1cidq5gv8blvf6pyw6pnw6vq";
      name = "qtlanguageserver-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtlocation-everywhere-src-6.9.2.tar.xz";
      sha256 = "1ybk3ig69p6zyrxabcfkb4pcyc251gy1m2brkf4q52cmcwcysias";
      name = "qtlocation-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtlottie-everywhere-src-6.9.2.tar.xz";
      sha256 = "1iiigsb4p1zwkxm1x9c4pbx5rgwz35krdqi3vkql4nawvp997px4";
      name = "qtlottie-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtmultimedia-everywhere-src-6.9.2.tar.xz";
      sha256 = "04mbwl1mg4rjgai027chldslpjnqrx52c3jxn20j2hx7ayda3y3v";
      name = "qtmultimedia-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtnetworkauth-everywhere-src-6.9.2.tar.xz";
      sha256 = "114c65gyg56v70byyl3if1q7mzhp5kkv1g8sp4y9zaxqirbdjr91";
      name = "qtnetworkauth-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtpositioning-everywhere-src-6.9.2.tar.xz";
      sha256 = "06mwzlyprwz11ks6fsvzh03ilk5fxy3scr1gqqb4p85xzw0ri6j8";
      name = "qtpositioning-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtquick3d-everywhere-src-6.9.2.tar.xz";
      sha256 = "002888xfnkxmvn8413fllidl3mm2fcwc4gbzdnbvpjlysaq9f3ig";
      name = "qtquick3d-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtquick3dphysics-everywhere-src-6.9.2.tar.xz";
      sha256 = "12yc0lswcmyaw19yyxzy73j95ncgqw8mlx8svhrwsllgcf2n9z47";
      name = "qtquick3dphysics-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtquickeffectmaker-everywhere-src-6.9.2.tar.xz";
      sha256 = "1yfq1pp0k2d6438x8pn2y73y29bqwg45bjh6msiy64fldr4z31br";
      name = "qtquickeffectmaker-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtquicktimeline-everywhere-src-6.9.2.tar.xz";
      sha256 = "09n51qw0y8v1q83xs1ybwwm4a49j2qhshqrasdkzz25mij6nhrdw";
      name = "qtquicktimeline-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtremoteobjects-everywhere-src-6.9.2.tar.xz";
      sha256 = "09lby6dqc2sfig1krcszg6fkypgxlz2r7hgjjfi95g7g9gqlwqnz";
      name = "qtremoteobjects-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtscxml-everywhere-src-6.9.2.tar.xz";
      sha256 = "1dpb687zbw4akx42kfpbb5cpdlq3hcqn8l3l0x7sd5i9061z2sp0";
      name = "qtscxml-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtsensors-everywhere-src-6.9.2.tar.xz";
      sha256 = "0qj4674vim2p34mq3kp99spjyf82qvs75w625namzqp274pshk4n";
      name = "qtsensors-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtserialbus-everywhere-src-6.9.2.tar.xz";
      sha256 = "0xia9xcz7sjrbf1c4m63qnhz3ggdxr06pycslmsnqizlzb10f7lm";
      name = "qtserialbus-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtserialport-everywhere-src-6.9.2.tar.xz";
      sha256 = "0sz2dkas4qjdd6lkfb9g89vi94q18aiq9xdchlqb2yn0qbqb544b";
      name = "qtserialport-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtshadertools-everywhere-src-6.9.2.tar.xz";
      sha256 = "158lpzb1nqspwm0n48d3nfr81q85zka1igrjp6xj8cjlv7wqlrqp";
      name = "qtshadertools-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtspeech-everywhere-src-6.9.2.tar.xz";
      sha256 = "1cc8l2h1frlraay0m40r5a91nsc7b53n6vksa52pwqqia4vngdmj";
      name = "qtspeech-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtsvg-everywhere-src-6.9.2.tar.xz";
      sha256 = "1985asvnkd2ar30nh2zyi490qz0vkz6z1f752lfald33yawcm16r";
      name = "qtsvg-everywhere-src-6.9.2.tar.xz";
    };
  };
  qttools = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qttools-everywhere-src-6.9.2.tar.xz";
      sha256 = "12d4czfwvh9rfjwnkpsiwzrpx4ga69c6vz85aabhpk3hx7lggdyq";
      name = "qttools-everywhere-src-6.9.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qttranslations-everywhere-src-6.9.2.tar.xz";
      sha256 = "1mky3xj2yhcsrmpz8m28v7pky6ryn7hvdcglakww0rfk3qlbcfy7";
      name = "qttranslations-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtvirtualkeyboard-everywhere-src-6.9.2.tar.xz";
      sha256 = "1qqizh7kyqbqqnrm1mmlf2709rm1rnflbqdl1bi75yms07d00hbv";
      name = "qtvirtualkeyboard-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtwayland-everywhere-src-6.9.2.tar.xz";
      sha256 = "10bpxwpam56gvymz9vjxkppbqsj1369ddzl3k4pz2s2maq39imya";
      name = "qtwayland-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtwebchannel-everywhere-src-6.9.2.tar.xz";
      sha256 = "0rcf7i1wamdf1qynq3yi88r77ch5dg1jinxywlfjlb2dmlvn72l7";
      name = "qtwebchannel-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtwebengine-everywhere-src-6.9.2.tar.xz";
      sha256 = "1aq35nkgbvhlsmglnjizbkavr7kb0ymf5n3kkllrpqy2mf90gjwr";
      name = "qtwebengine-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtwebsockets-everywhere-src-6.9.2.tar.xz";
      sha256 = "1vh82w96436pqrp4daf324mqs2zjvn51z78b3ksc5mnqgrk3z0xy";
      name = "qtwebsockets-everywhere-src-6.9.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.9.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.2/submodules/qtwebview-everywhere-src-6.9.2.tar.xz";
      sha256 = "1w8z3d7w7z2xjfb5l15gb37v9w6pa7d71jalkrqda8l2wr5d3ksc";
      name = "qtwebview-everywhere-src-6.9.2.tar.xz";
    };
  };
}
