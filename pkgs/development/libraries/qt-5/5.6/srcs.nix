# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qt3d-opensource-src-5.6.3.tar.xz";
      sha256 = "1zkzc3wh2i89nacb55mbgl09zhrjbrxg9ir626bsvz15x4q5ml0h";
      name = "qt3d-opensource-src-5.6.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtactiveqt-opensource-src-5.6.3.tar.xz";
      sha256 = "00qscqjpkv5ssrjdwwcjp9q1rqgp8lsdjjksjpyyg4v6knd74s0i";
      name = "qtactiveqt-opensource-src-5.6.3.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtandroidextras-opensource-src-5.6.3.tar.xz";
      sha256 = "1v19p1pqcdicylj3hd2lbm5swqddydlv9aqmws3qwsc2vwh15d4n";
      name = "qtandroidextras-opensource-src-5.6.3.tar.xz";
    };
  };
  qtbase = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtbase-opensource-src-5.6.3.tar.xz";
      sha256 = "18ad7cxln61276cm8h8hzm0y6svw6b5m5nbm1niif9pwlqlqbx7y";
      name = "qtbase-opensource-src-5.6.3.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtcanvas3d-opensource-src-5.6.3.tar.xz";
      sha256 = "1zsn3xbsqapivfg80cldjlh7z07nf88958a7g6dm7figkwahx7p9";
      name = "qtcanvas3d-opensource-src-5.6.3.tar.xz";
    };
  };
  qtcharts = {
    version = "2.1.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtcharts-opensource-src-2.1.3.tar.xz";
      sha256 = "0bvxmqx7094mq1svrv1i1jp6vl87r2mp7k9n3gqpixjmqaqsjdpn";
      name = "qtcharts-opensource-src-2.1.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtconnectivity-opensource-src-5.6.3.tar.xz";
      sha256 = "1pnc0zmps5iw5yhn2w0wl8cnyxhcy88d3rnaiv62ljpsccynwh7s";
      name = "qtconnectivity-opensource-src-5.6.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "1.2.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtdatavis3d-opensource-src-1.2.3.tar.xz";
      sha256 = "0rqhr6s3fic91r6r1g2ws57j6ixvkh4zhcwh7savs1risx374vya";
      name = "qtdatavis3d-opensource-src-1.2.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtdeclarative-opensource-src-5.6.3.tar.xz";
      sha256 = "1z4ih5jbydnk5dz0arhvwc54fjw7fynqx3rhm6f8lsyis19w0gzn";
      name = "qtdeclarative-opensource-src-5.6.3.tar.xz";
    };
  };
  qtdeclarative-render2d = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtdeclarative-render2d-opensource-src-5.6.3.tar.xz";
      sha256 = "0r2qn8l3wh73cj75rq34zmc6rgl7v11c31pjdcsybad76nw5wb2p";
      name = "qtdeclarative-render2d-opensource-src-5.6.3.tar.xz";
    };
  };
  qtdoc = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtdoc-opensource-src-5.6.3.tar.xz";
      sha256 = "11zhlry8hlql1q3pm4mf7qyky9i2irxqdrr9nr5m93wjyfsjbh7f";
      name = "qtdoc-opensource-src-5.6.3.tar.xz";
    };
  };
  qtenginio = {
    version = "1.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtenginio-opensource-src-1.6.3.tar.xz";
      sha256 = "04ir5pa8wpkc7cq08s0b69a0vhkr7479ixn3m2vww4jm6l5hc1yr";
      name = "qtenginio-opensource-src-1.6.3.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtgraphicaleffects-opensource-src-5.6.3.tar.xz";
      sha256 = "1vcrm4jfmxjlw23dnwf45mzq2z5s4fz6j2znknr25ca5bqnmjhn7";
      name = "qtgraphicaleffects-opensource-src-5.6.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtimageformats-opensource-src-5.6.3.tar.xz";
      sha256 = "1hs8b258xsbc4xb4844mas9ka54f5cfhhszblawwjxn9j0ydmr7g";
      name = "qtimageformats-opensource-src-5.6.3.tar.xz";
    };
  };
  qtlocation = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtlocation-opensource-src-5.6.3.tar.xz";
      sha256 = "0rhlmyi5kkhl1bimaj1fmp36v7x5r79j3flgx9dv27rkric1ra5p";
      name = "qtlocation-opensource-src-5.6.3.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtmacextras-opensource-src-5.6.3.tar.xz";
      sha256 = "10v2a058yv6k76gg9dgpy4fc0xd652dknzsw5432gm8d9391382i";
      name = "qtmacextras-opensource-src-5.6.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtmultimedia-opensource-src-5.6.3.tar.xz";
      sha256 = "0ihvbv0ldravbrx6406ps0z8y6521iz6h58n5ws44xq3m2g06dmf";
      name = "qtmultimedia-opensource-src-5.6.3.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtpurchasing-opensource-src-5.6.3.tar.xz";
      sha256 = "0lf269jzd6y4x5bxjwgz9dpw7hxmc6sp39qpxwlswd505cf0wgd7";
      name = "qtpurchasing-opensource-src-5.6.3.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtquickcontrols-opensource-src-5.6.3.tar.xz";
      sha256 = "13nvn0d2i4lf4igc1xqf7m98n4j66az1bi02zzv5m18vyb40zfri";
      name = "qtquickcontrols-opensource-src-5.6.3.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtquickcontrols2-opensource-src-5.6.3.tar.xz";
      sha256 = "1jw1zykrx8aa9p781hc74h9za7lnnm4ifpdyqa4ahbdy193phl7c";
      name = "qtquickcontrols2-opensource-src-5.6.3.tar.xz";
    };
  };
  qtscript = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtscript-opensource-src-5.6.3.tar.xz";
      sha256 = "12dkf2s1l9y9cwdyayg2mpnwvx14kq93pymp3iy3fw1s1vfj11zh";
      name = "qtscript-opensource-src-5.6.3.tar.xz";
    };
  };
  qtsensors = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtsensors-opensource-src-5.6.3.tar.xz";
      sha256 = "0ws96fmk5zz9szrw9x1dwa6gnv9rpv1q0h9ax9z5m1kiapfd80km";
      name = "qtsensors-opensource-src-5.6.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtserialbus-opensource-src-5.6.3.tar.xz";
      sha256 = "17lskz4r549hc02riv0a3jdjbyaq4y4a94xd3jhy454lhzirpj3i";
      name = "qtserialbus-opensource-src-5.6.3.tar.xz";
    };
  };
  qtserialport = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtserialport-opensource-src-5.6.3.tar.xz";
      sha256 = "06mfkd88rcn4p8pfzsyqbfg956vwwcql0khchjgx3bh34zp1yb88";
      name = "qtserialport-opensource-src-5.6.3.tar.xz";
    };
  };
  qtsvg = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtsvg-opensource-src-5.6.3.tar.xz";
      sha256 = "1v6wz8fcgsh4lfv68bhavms0l1z3mcn8vggakc3m8rdl2wsih3qh";
      name = "qtsvg-opensource-src-5.6.3.tar.xz";
    };
  };
  qttools = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qttools-opensource-src-5.6.3.tar.xz";
      sha256 = "09krlrgcglylsv7xx4r681v7zmyy6nr8j18482skrmsqh21vlqqs";
      name = "qttools-opensource-src-5.6.3.tar.xz";
    };
  };
  qttranslations = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qttranslations-opensource-src-5.6.3.tar.xz";
      sha256 = "1avcfymi9bxk02i1rqh89c6hnvf4bg9qry94z29g1r62c80lxvbd";
      name = "qttranslations-opensource-src-5.6.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "2.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtvirtualkeyboard-opensource-src-2.0.tar.xz";
      sha256 = "1v0saqz76h9gnb13b8mri4jq93i7f1gr7hj81zj3vz433s2klm0x";
      name = "qtvirtualkeyboard-opensource-src-2.0.tar.xz";
    };
  };
  qtwayland = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwayland-opensource-src-5.6.3.tar.xz";
      sha256 = "18ys14fzjybx02aj85vyqzsp89ypv2c6vfpklxzslwyvn9w54iss";
      name = "qtwayland-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwebchannel-opensource-src-5.6.3.tar.xz";
      sha256 = "04q7wmdnv4pskah2s5nnrzbsb207fvkj333m69wkqrc64anb1ccf";
      name = "qtwebchannel-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwebengine-opensource-src-5.6.3.tar.xz";
      sha256 = "19xpvnjwrjpj6wx7sy1cs1r1ibnh5hqfk9w9rnqf5h7n77xnk780";
      name = "qtwebengine-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebkit = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/community_releases/5.6/5.6.3/qtwebkit-opensource-src-5.6.3.tar.xz";
      sha256 = "15iqgaw3jznfq1mdg1mmr7pn8w3qhw964h5m36vg3ywqayr6p309";
      name = "qtwebkit-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebkit-examples = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/community_releases/5.6/5.6.3/qtwebkit-examples-opensource-src-5.6.3.tar.xz";
      sha256 = "17hnls8j4wz0kyzzq7m3105lqz71zsxr0hya7i23pl4qc8affv1d";
      name = "qtwebkit-examples-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwebsockets-opensource-src-5.6.3.tar.xz";
      sha256 = "1sr8q0wqw4xwcdl6nvnv04pcjxb0fbs4ywrkcghdz2bcc52r0hx2";
      name = "qtwebsockets-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwebview = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwebview-opensource-src-5.6.3.tar.xz";
      sha256 = "076q9g2ca41v8lyhn7354rs8w2ca0wp2hsxc76zprzghi5p4b2kn";
      name = "qtwebview-opensource-src-5.6.3.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtwinextras-opensource-src-5.6.3.tar.xz";
      sha256 = "0nmhvd1g18w12q6i8s87aq7rwikcn1m8m9m0a02l3p22xvimkxzf";
      name = "qtwinextras-opensource-src-5.6.3.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtx11extras-opensource-src-5.6.3.tar.xz";
      sha256 = "0zv70z5z48wlg0q2zd7nbp7i0wimdcalns6yg0mjp7v2w2b8wyhy";
      name = "qtx11extras-opensource-src-5.6.3.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.6.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.3/submodules/qtxmlpatterns-opensource-src-5.6.3.tar.xz";
      sha256 = "1xjimf88j2s5jrqgr9ki82zmis8r979rrzq4k6dxw43k1ngzyqd4";
      name = "qtxmlpatterns-opensource-src-5.6.3.tar.xz";
    };
  };
}
