# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/5.15
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qt3d-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1k5lkc6fiwx9rznq9vv383hhcglva7f1v3pkzis7g1jwjh6g5d9l";
      name = "qt3d-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtactiveqt-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "02qd4wxkfhgixaf7z757jb972cx27r5qhp8fys5mk0i6ndlr4an8";
      name = "qtactiveqt-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtandroidextras-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "14li461wyq04pvz7g5badj7izvwqzizf4g3wdzn26pyffj2sy1kl";
      name = "qtandroidextras-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtbase = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtbase-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1dm0yf3rfn2mqgazv4bgkfz8sswwc6qqkdnp5dcw2ljx6z4lwf96";
      name = "qtbase-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtcharts = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtcharts-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1br32sv4nx9xcv43hsk0vvvkipxrr10qf2ds9hpx8ha6lv6qbkxc";
      name = "qtcharts-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtcoap = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtcoap-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1kdkrvmbc0kw4l4nmh82zwcw4m30lnzknbr5y05pm0r5nra8pgjx";
      name = "qtcoap-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtconnectivity-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1hb5y90zv6qrxl50achpnrihx4lk4h7aq1dg00lbwj1jmhfxlzzi";
      name = "qtconnectivity-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtdatavis3d-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1n5a8rpf22y7dzw250xwb3l0nhl8wbaimlzw1qj14rcx4fvky4np";
      name = "qtdatavis3d-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtdeclarative-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0qj06z21clmrvf6r4lq4z565x9kwrwn48rl457wds6s5m9f5mw9k";
      name = "qtdeclarative-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtdoc = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtdoc-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0hqhg4g3mqysybmh9cclxbmczzb3v04gsvrjyxclm5pawanlpw1f";
      name = "qtdoc-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtgamepad-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0gqczl8jkww1shq4nffszzn8h1iakbgdxf5kbbkd5jcv1zrvzgfy";
      name = "qtgamepad-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtgraphicaleffects-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0swgc8g5zbsg6b7ihnl796psalgl4i751px9ir7lpcib41gqakp2";
      name = "qtgraphicaleffects-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtimageformats-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "08p2ahm58ah173bl2jkj7rr2lv4wd1z1agbfibcx2agi1j4ijxkl";
      name = "qtimageformats-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtknx = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtknx-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "13cgg1bcgqpn9677pdhwxk37aqm8y5fzasbk6lx8kqvk76rf6r3r";
      name = "qtknx-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtlocation = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtlocation-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1gbb5ji0is9ijz95pxgj6vl4n9ki3pa7ic9i06gfdy2fzp62i7x6";
      name = "qtlocation-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtlottie = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtlottie-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "140lrjhhrlxla764lbywlxzw6gk7fwv8chrb6ims6cf8a3kabrfs";
      name = "qtlottie-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtmacextras-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "11yqi99g3hw7vijs7xigzvvjpsrcq57kixsq7j7amh1ngc608kcv";
      name = "qtmacextras-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtmqtt = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtmqtt-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0nyh9s0kp432vdq0al0caxsmjizsk1j72vnfibcf2xp7idgyr1mh";
      name = "qtmqtt-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtmultimedia-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1w06wq6ffndq5jvd9irr1dkrps610vjrsnyi9w3sl25q40vs7fif";
      name = "qtmultimedia-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtnetworkauth-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "08p5pr862xy75k27iy93f1kj0vq41mzp9b86f0a09pai0ak6v7pv";
      name = "qtnetworkauth-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtopcua = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtopcua-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1pnbjv7qciqilyivjndz6bmqpby0hjby72ais24q2z3vy4kllj2a";
      name = "qtopcua-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtpurchasing-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1x62kbhw9hjlxv4livr9wca48ly18d2bz0aic88298jz1hvl3yhb";
      name = "qtpurchasing-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtquick3d-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1bff10xgx1andnpicfcg9baikppqflw7rgqh0jcbja3xjm2mcsi3";
      name = "qtquick3d-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtquickcontrols-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1w1h0bj4qif43b6z94njl1zn800d4k7f6fsyrg2f9zca5v7ayd20";
      name = "qtquickcontrols-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtquickcontrols2-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0bsnmx32qrqrndqxygp3c5naw0x4b5j121d8qks1inf3b2zfk59v";
      name = "qtquickcontrols2-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtquicktimeline-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1k7295107w33ffdi8246fjf3qnb4dr612zhnjnhbgk7f98qqc8lz";
      name = "qtquicktimeline-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtremoteobjects-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0g0jdd32w69n145b5ixahkivvy3fagdwwikp7ky9lrcra7axwd2y";
      name = "qtremoteobjects-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtscript = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtscript-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0g1l836m01vn63x7vphc3qff593042zg22sjnkyh6wagswakh17h";
      name = "qtscript-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtscxml = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtscxml-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0kkwfjh0vfdy96ijkcxirilv20qil172ag0vfybnq9pr1swx80sx";
      name = "qtscxml-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtsensors = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtsensors-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "17x52yhy6a6ymqkm0svbfjrfnd3i4bzn6989dcgjwy0xzc3vpjsa";
      name = "qtsensors-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtserialbus-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1rcxz1zp1nrmzkpc3f27pas7g1pmx0jri3vfqwis31gnlyky9gzq";
      name = "qtserialbus-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtserialport = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtserialport-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0cmfvga0f4qcr2p02lsiblvlgc4ch081cdx8drvhi1fmb3kp8ad1";
      name = "qtserialport-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtspeech = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtspeech-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "0aw59d9iw89fzjzlrrzbf1rjjwqnaykppn67hhbg25jjrczwv9sq";
      name = "qtspeech-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtsvg = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtsvg-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "12axa2h1yx6v9kjmhsjk8l3jfpp71v1xlfsmzywf7fv7rkgl3p1s";
      name = "qtsvg-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qttools = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qttools-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "03grapgya9y4abvhhykdjrxqbv5h18vawcwkwfs7lph83bkjyfs6";
      name = "qttools-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qttranslations = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qttranslations-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1c1dym54v47qrpwkhwsp14msxfymklxq2rp2hq4ssdd1f3v6jy2x";
      name = "qttranslations-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtvirtualkeyboard-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "10k3s0igxxkh1mspccnyf7j50vrywswigbya45cw11xyv2bzhxvs";
      name = "qtvirtualkeyboard-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwayland = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwayland-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "02r4151g57x1hfc7syhkqk1784rq3a0jlzm3kbrsggr5amndlsk8";
      name = "qtwayland-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwebchannel-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1sq2af22j0dh28b4lycic4qjfir9gpx0ym0i6350as7ssbmik81g";
      name = "qtwebchannel-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwebengine-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1jwrrqwrhkl73q4z06za396n3zqwznqlxa6vbp9m4rk8x6gyd9ps";
      name = "qtwebengine-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwebglplugin = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwebglplugin-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "081qilqg9g29dl2aam71am5bxc9q1zr1znn1jar63f6b12s52rzw";
      name = "qtwebglplugin-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwebsockets-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1lakv2p7vcnafyz40v0nkskslahq06g61lf1gmia4yfs6z2zdjcp";
      name = "qtwebsockets-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwebview = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwebview-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "07fk22l0jyg1l814gfx677aag8di0lrf43ggz69ffmbji5iv0yhq";
      name = "qtwebview-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtwinextras-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1wj36w8lrzkq0x5hd97nynbd3p3aqqbx0y0zmjqwx3ccmdfclb17";
      name = "qtwinextras-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtx11extras-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1f1ybrqjdhib8p0h19ww69ir804yvbcrxqky815r9gbkv94b1ad3";
      name = "qtx11extras-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.15.3";
    src = fetchurl {
      url = "${mirror}/archive/qt/5.15/5.15.3/submodules/qtxmlpatterns-everywhere-opensource-src-5.15.3.tar.xz";
      sha256 = "1bbzrhcjivpr6a40hs798ic6r787d2yfwc8j4wd402whz7rrhcv0";
      name = "qtxmlpatterns-everywhere-opensource-src-5.15.3.tar.xz";
    };
  };
}
