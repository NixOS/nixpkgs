# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.15/
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qt3d-everywhere-src-5.15.2.tar.xz";
      sha256 = "07awqpad6xzq2v7mc9lxns0845mbhh8p4pczq6b55iqkr146mv83";
      name = "qt3d-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtactiveqt-everywhere-src-5.15.2.tar.xz";
      sha256 = "0p1aml81bw99a58vx301s3zikgv72s6xbgnmkh3ifvc7w3z630c6";
      name = "qtactiveqt-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtandroidextras-everywhere-src-5.15.2.tar.xz";
      sha256 = "1gfsr25cypxdjl6w99q2kxpxwd0053y9gxnc5qirr6nqj232f4sq";
      name = "qtandroidextras-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtbase = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtbase-everywhere-src-5.15.2.tar.xz";
      sha256 = "1y70libf2x52lpbqvhz10lpk7nyl1ajjwzjxly9pjdpfj4jsv7wh";
      name = "qtbase-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtcharts = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtcharts-everywhere-src-5.15.2.tar.xz";
      sha256 = "049x7z8zcp9jixmdv2fjscy2ggpd6za9hkdbb2bqp2mxjm0hwxg0";
      name = "qtcharts-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtconnectivity-everywhere-src-5.15.2.tar.xz";
      sha256 = "185zci61ip1wpjrygcw2m6v55lvninc0b8y2p3jh6qgpf5w35003";
      name = "qtconnectivity-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtdatavis3d-everywhere-src-5.15.2.tar.xz";
      sha256 = "1zdn3vm0nfy9ny7c783aabp3mhlnqhi9fw2rljn7ibbksmsnasi2";
      name = "qtdatavis3d-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtdeclarative-everywhere-src-5.15.2.tar.xz";
      sha256 = "0lancdn7y0lrlmyn5cbdm0izd5yprvd5n77nhkb7a3wl2sbx0066";
      name = "qtdeclarative-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtdoc = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtdoc-everywhere-src-5.15.2.tar.xz";
      sha256 = "1r2cf6khs8b2yp8nf0afm0yx85vpzqpv77399v591mhv1zq0jy54";
      name = "qtdoc-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtgamepad-everywhere-src-5.15.2.tar.xz";
      sha256 = "0p07bg93fdfn4gr2kv38qgnws5znhswajrxdfs8xc9l3i7vi2xn7";
      name = "qtgamepad-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtgraphicaleffects-everywhere-src-5.15.2.tar.xz";
      sha256 = "1r6zfc0qga2ax155js7c8y5rx6vgayf582s921j09mb797v6g3gc";
      name = "qtgraphicaleffects-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtimageformats-everywhere-src-5.15.2.tar.xz";
      sha256 = "1msk8a0z8rr16hkp2fnv668vf6wayiydqgc2mcklaa04rv3qb0mz";
      name = "qtimageformats-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtlocation = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtlocation-everywhere-src-5.15.2.tar.xz";
      sha256 = "184jychnlfhplpwc5cdcsapwljgwvzk5qpf3val4kpq8w44wnkwq";
      name = "qtlocation-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtlottie = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtlottie-everywhere-src-5.15.2.tar.xz";
      sha256 = "05r58gfgdl1ppqmc9bckhz763541zp2ahgmds84yc57pp1d0kinf";
      name = "qtlottie-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtmacextras-everywhere-src-5.15.2.tar.xz";
      sha256 = "0vkpp318z86nk0vc5j9kz9ahx1ihfiwsnv7k01ldc767rvrb0nb9";
      name = "qtmacextras-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtmultimedia-everywhere-src-5.15.2.tar.xz";
      sha256 = "1xbd6kc7i0iablqdkvfrajpi32cbq7j6ajbfyyyalcai1s0mhdqc";
      name = "qtmultimedia-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtnetworkauth-everywhere-src-5.15.2.tar.xz";
      sha256 = "11fdgacv4syr8bff2vdw7rb0dg1gcqpdf37hm3pn31d6z91frhpw";
      name = "qtnetworkauth-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtpurchasing-everywhere-src-5.15.2.tar.xz";
      sha256 = "09rjx53519dfk4qj2gbn3vlxyriasyb747wpg1p11y7jkwqhs4l7";
      name = "qtpurchasing-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtquick3d-everywhere-src-5.15.2.tar.xz";
      sha256 = "1fwl5wy48j74bsv1028s5hi2x45lxc2z68kgf7j39kk56cr4c1av";
      name = "qtquick3d-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtquickcontrols-everywhere-src-5.15.2.tar.xz";
      sha256 = "1dczakl868mg0lnwpf082jjc5976ycn879li1vqlgw5ihirzp4y3";
      name = "qtquickcontrols-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtquickcontrols2-everywhere-src-5.15.2.tar.xz";
      sha256 = "06c9vrwvbjmzapmfa25y34lgjkzg57xxbm92nr6wkv5qykjnq6v7";
      name = "qtquickcontrols2-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtquicktimeline-everywhere-src-5.15.2.tar.xz";
      sha256 = "0a1ahgxqs4pwx6qvs8lxkhv2178p8sniipf7qz77lhq7fqi4ghmr";
      name = "qtquicktimeline-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtremoteobjects-everywhere-src-5.15.2.tar.xz";
      sha256 = "1hngbp0vkr35rpsrac7b9vx6f360v8v2g0fffzm590l8j2ybd0b7";
      name = "qtremoteobjects-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtscript = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtscript-everywhere-src-5.15.2.tar.xz";
      sha256 = "0gk74hk488k9ldacxbxcranr3arf8ifqg8kz9nm1rgdgd59p36d2";
      name = "qtscript-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtscxml = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtscxml-everywhere-src-5.15.2.tar.xz";
      sha256 = "1p5771b9hnpchfcdgy0zkhwg09a6xq88934aggp0rij1k85mkfb0";
      name = "qtscxml-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtsensors = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtsensors-everywhere-src-5.15.2.tar.xz";
      sha256 = "0fa81r7bn1mf9ynwsx524a55dx1q0jb4vda6j48ssb4lx7wi201z";
      name = "qtsensors-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtserialbus-everywhere-src-5.15.2.tar.xz";
      sha256 = "125x6756fjpldqy6wbw6cg7ngjh2016aiq92bchh719z1mf7xsxf";
      name = "qtserialbus-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtserialport = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtserialport-everywhere-src-5.15.2.tar.xz";
      sha256 = "17gp5qzg4wdg8qlxk2p3mh8x1vk33rf33wic3fy0cws193bmkiar";
      name = "qtserialport-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtspeech = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtspeech-everywhere-src-5.15.2.tar.xz";
      sha256 = "1xc3x3ghnhgchsg1kgj156yg69wn4rwjx8r28i1jd05hxjggn468";
      name = "qtspeech-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtsvg = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtsvg-everywhere-src-5.15.2.tar.xz";
      sha256 = "0pjqrdmd1991x9h4rl8sf81pkd89hfd5h1a2gp3fjw96pk0w5hwb";
      name = "qtsvg-everywhere-src-5.15.2.tar.xz";
    };
  };
  qttools = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qttools-everywhere-src-5.15.2.tar.xz";
      sha256 = "1k618f7v6jaj0ygy8d7jvgb8zjr47sn55kiskbdkkizp3z7d12f1";
      name = "qttools-everywhere-src-5.15.2.tar.xz";
    };
  };
  qttranslations = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qttranslations-everywhere-src-5.15.2.tar.xz";
      sha256 = "1f0daxgjn1fxjmdb80sy3qfhjgi1d8vr9z8y7wrda8bv4n38wy6m";
      name = "qttranslations-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtvirtualkeyboard-everywhere-src-5.15.2.tar.xz";
      sha256 = "0mfgd1mpi8lpik5fjfm6i0zrnbkdd7ww5f73jsl0j3z37f8r6ccs";
      name = "qtvirtualkeyboard-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwayland = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwayland-everywhere-src-5.15.2.tar.xz";
      sha256 = "1ddfx4nak16xx0zh1kl836zxvpbixmmjyplsmfmg65pqkwi34dqr";
      name = "qtwayland-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwebchannel-everywhere-src-5.15.2.tar.xz";
      sha256 = "1h9y634phvvk557mhmf9z4lmxr41rl8x9mqy2lzp31mk8ffffzqj";
      name = "qtwebchannel-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwebengine-everywhere-src-5.15.2.tar.xz";
      sha256 = "1q4idxdm81sx102xc12ixj0xpfx52d6vwvs3jpapnkyq8c7cmby8";
      name = "qtwebengine-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwebglplugin-everywhere-src-5.15.2.tar.xz";
      sha256 = "0ihlnhv8ldkqz82v3j7j22lrhk17b6ghra8sx85y2agd2ysq5rw1";
      name = "qtwebglplugin-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwebsockets-everywhere-src-5.15.2.tar.xz";
      sha256 = "0gr399fn5n8j3m9d3vv01vcbr1cb7pw043j04cnnxzrlvn2jvd50";
      name = "qtwebsockets-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwebview = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwebview-everywhere-src-5.15.2.tar.xz";
      sha256 = "1rw1wibmbxlj6xc86qs3y8h42al1vczqiksyxzaylxs9gqb4d7xy";
      name = "qtwebview-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtwinextras-everywhere-src-5.15.2.tar.xz";
      sha256 = "03jmmg2g8k4qdma4xrfqpfii6cqydlkap0bxmf8hgh6y0lh2gf35";
      name = "qtwinextras-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtx11extras-everywhere-src-5.15.2.tar.xz";
      sha256 = "0gkfzj195v9flwljnqpdz3a532618yn4h2577nlsai56x4p7053h";
      name = "qtx11extras-everywhere-src-5.15.2.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.15.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.15/5.15.2/submodules/qtxmlpatterns-everywhere-src-5.15.2.tar.xz";
      sha256 = "1ypj5jpa31rlx8yfw3y9jia212lfnxvnqkvygs6ihjf3lxi23skn";
      name = "qtxmlpatterns-everywhere-src-5.15.2.tar.xz";
    };
  };
}
