# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qt3d-everywhere-src-6.4.2.tar.xz";
      sha256 = "0hbkld6ys78xvd2npbnbajdqiyjjskzfi7xp43kp60l4sg1j8v25";
      name = "qt3d-everywhere-src-6.4.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qt5compat-everywhere-src-6.4.2.tar.xz";
      sha256 = "14mpqj9ci31nn2n68czmxqdiikkg5iw7vqiksyvm2nwqirf507zm";
      name = "qt5compat-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtactiveqt-everywhere-src-6.4.2.tar.xz";
      sha256 = "1ky5gp251r4lslc2wnmiy44p231zrqmdgb73m28kl9ii9rn0wg8j";
      name = "qtactiveqt-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtbase-everywhere-src-6.4.2.tar.xz";
      sha256 = "0paj0p3j3nvdcp9xnpzrsjxcyy6fr9wslav2kaj7hj5kvg7cd2x8";
      name = "qtbase-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtcharts-everywhere-src-6.4.2.tar.xz";
      sha256 = "1am9s1wahbfz1gvv5db31b8aw6k86wzyp8n3s6bwyw48ikhc19x1";
      name = "qtcharts-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtconnectivity-everywhere-src-6.4.2.tar.xz";
      sha256 = "1bypqp6szqp6wp5npyqv585qk2760iwl4pyadx6lqaz476r496wc";
      name = "qtconnectivity-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtdatavis3d-everywhere-src-6.4.2.tar.xz";
      sha256 = "1m145mxgx1hgd8c3kdnjblvq50a8hycihn0a1ibc1y3a3phpp4l3";
      name = "qtdatavis3d-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtdeclarative-everywhere-src-6.4.2.tar.xz";
      sha256 = "1ggm612fv7ahizd0c2ip9rai31srv2ypsxjvz2hbr72fvs1xkgd4";
      name = "qtdeclarative-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtdoc-everywhere-src-6.4.2.tar.xz";
      sha256 = "178kp7jkam2j5slccv3xkfi21ah9q1kj44kh71kg8sgc7v3fn7sa";
      name = "qtdoc-everywhere-src-6.4.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qthttpserver-everywhere-src-6.4.2.tar.xz";
      sha256 = "1i8bkcz08ya53mvgilwxifr8sfpa599fxmc21cicqxypcx1a9cql";
      name = "qthttpserver-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtimageformats-everywhere-src-6.4.2.tar.xz";
      sha256 = "01qpw7pbk6q3vqradjvcry0yp1jk67fx8mkra3ang6kpw2d9jpzw";
      name = "qtimageformats-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtlanguageserver-everywhere-src-6.4.2.tar.xz";
      sha256 = "04d83hjbfgapzsfqm6zmqm8jjplih0k2psx35c1vnzqaxz36cgkl";
      name = "qtlanguageserver-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtlottie-everywhere-src-6.4.2.tar.xz";
      sha256 = "0mhwvv8n3y0j0x471qprg5d18d8js9ic6c1s6xdwx590qxlqik5c";
      name = "qtlottie-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtmultimedia-everywhere-src-6.4.2.tar.xz";
      sha256 = "0xn7fa4z4mm8pzvd2hyms6jrgwjpcql02a0fcs71r4fsxbg70avz";
      name = "qtmultimedia-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtnetworkauth-everywhere-src-6.4.2.tar.xz";
      sha256 = "1vn28x83079zdf41lrmrdxclg0cif09cfyvmswxlj2kxjnyigayy";
      name = "qtnetworkauth-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtpositioning-everywhere-src-6.4.2.tar.xz";
      sha256 = "10pgkag7bjhh1yxq3fm2szch17q1fmh2xly926rgayl7pbsvl0bz";
      name = "qtpositioning-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtquick3d-everywhere-src-6.4.2.tar.xz";
      sha256 = "19r655jinshg210ik1mann57ic92bvr52gd3xqy5c06wlrn3ngcm";
      name = "qtquick3d-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtquick3dphysics-everywhere-src-6.4.2.tar.xz";
      sha256 = "14fc4fzcpx4phqf768cavkwxxzhccz7hgif4g5a6xcirdimzhyp8";
      name = "qtquick3dphysics-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtquicktimeline-everywhere-src-6.4.2.tar.xz";
      sha256 = "0plsy3pz589hrzjz717vmpsy60rl7hf9sl519qsjldkqyjvsp21h";
      name = "qtquicktimeline-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtremoteobjects-everywhere-src-6.4.2.tar.xz";
      sha256 = "04l88akwawyippzc4j82wd4vn801fl6iibppxrld1m9001j56g2q";
      name = "qtremoteobjects-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtscxml-everywhere-src-6.4.2.tar.xz";
      sha256 = "0zsfylzbh3hwjii6l4y1ha524qrby3piyylnh4jfsjrrb4sd9c0k";
      name = "qtscxml-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtsensors-everywhere-src-6.4.2.tar.xz";
      sha256 = "0mp6gq3mlinmagb3gd4kr3zwibygzd91k7lwljmlr7x353zijmj5";
      name = "qtsensors-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtserialbus-everywhere-src-6.4.2.tar.xz";
      sha256 = "06xz91yn2vwybdwn8jgz6ymlbrdmpjsdwj07lnd8j9vkgiji6h30";
      name = "qtserialbus-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtserialport-everywhere-src-6.4.2.tar.xz";
      sha256 = "1yj08d810l4drsnhav3mych4p5b2dz5qrpn3nf20301pj28rav9k";
      name = "qtserialport-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtshadertools-everywhere-src-6.4.2.tar.xz";
      sha256 = "05x24v12jjh3fyr5wrxy7n33vqp00y10kyznrfs2r72f9pwbyrgs";
      name = "qtshadertools-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtspeech-everywhere-src-6.4.2.tar.xz";
      sha256 = "1jwlnh640qk602nn5zslrxmp87ph87fyp6jcysmh1xfn6j6rzjd9";
      name = "qtspeech-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtsvg-everywhere-src-6.4.2.tar.xz";
      sha256 = "0503b63zxqrakw33283lq8fm85asmpckibkyxpc22dkrn4yayimp";
      name = "qtsvg-everywhere-src-6.4.2.tar.xz";
    };
  };
  qttools = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qttools-everywhere-src-6.4.2.tar.xz";
      sha256 = "0s3chbap59allfkj825yi07wqcg9x10shgidabpsbr44c68qf4x3";
      name = "qttools-everywhere-src-6.4.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qttranslations-everywhere-src-6.4.2.tar.xz";
      sha256 = "15n4m6r279wqy9834iwc3n98nbyjbf9y2c7pzrr4nq6208ajkq5v";
      name = "qttranslations-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtvirtualkeyboard-everywhere-src-6.4.2.tar.xz";
      sha256 = "0a2gd8s7jrc56n4b743ln1qdvvl820cprp2zrbx6x28pdq7q6g4w";
      name = "qtvirtualkeyboard-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtwayland-everywhere-src-6.4.2.tar.xz";
      sha256 = "0pqkpvc21h3gkr8x7nxylxgksj046xgmqpc1nhvidasiyw51mkr4";
      name = "qtwayland-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtwebchannel-everywhere-src-6.4.2.tar.xz";
      sha256 = "11xxpvf53g63dxd6i6bzp4as4wc5pc6xlh3w7drnrwh94lmpnr86";
      name = "qtwebchannel-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtwebengine-everywhere-src-6.4.2.tar.xz";
      sha256 = "1j8rl5r981xdqh2sqzlw5md4z14h42f8sgjjfgpdkj0wim8lbagz";
      name = "qtwebengine-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtwebsockets-everywhere-src-6.4.2.tar.xz";
      sha256 = "09n64yjlkd6kcg4hk0j4f85spi1k3kanfvx50c0w486vh9sqbkvi";
      name = "qtwebsockets-everywhere-src-6.4.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.4.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.2/submodules/qtwebview-everywhere-src-6.4.2.tar.xz";
      sha256 = "0wpkn9pwbq3bn2yjxhvrmwb32rakknzgxbf8ybxwcly12la9chm6";
      name = "qtwebview-everywhere-src-6.4.2.tar.xz";
    };
  };
}
