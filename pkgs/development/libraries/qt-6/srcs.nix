# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qt3d-everywhere-src-6.4.1.tar.xz";
      sha256 = "1654hx04k6vdifjp5kr4sj6jm8qy8m8vna7yalmb3l55pr1k5dg4";
      name = "qt3d-everywhere-src-6.4.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qt5compat-everywhere-src-6.4.1.tar.xz";
      sha256 = "0cfh5z0kw75k2p3sca9d5gdfxvh93719prh2njg1nd6n8pp379fl";
      name = "qt5compat-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtactiveqt-everywhere-src-6.4.1.tar.xz";
      sha256 = "118ivyzh6xk92ak2qf0294n1fzziy2mxp2xgkblh801d3nbg7kql";
      name = "qtactiveqt-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtbase-everywhere-src-6.4.1.tar.xz";
      sha256 = "1bjgy9x75y82702xkv3bhxh3q9i37ny4fv3njb5zgj7rq0fdfajk";
      name = "qtbase-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtcharts-everywhere-src-6.4.1.tar.xz";
      sha256 = "0rwglk5g0k1x0vjb8j5r4fqaa7m31aykh42f18svkjpz3kbbrs6y";
      name = "qtcharts-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtconnectivity-everywhere-src-6.4.1.tar.xz";
      sha256 = "1qxvixv95wkb7h6ch1q39pxs7cidph6kyddz91qgxr2gznz5s3wv";
      name = "qtconnectivity-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtdatavis3d-everywhere-src-6.4.1.tar.xz";
      sha256 = "00ddsv4inbsqbgc7lc163j8fqx9r156xzsrilh9papidfm7yvrm9";
      name = "qtdatavis3d-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtdeclarative-everywhere-src-6.4.1.tar.xz";
      sha256 = "1zjdd2ndaywl7wgl9q94a1qwin5p45l2838lqhkdm3ckvdgli35g";
      name = "qtdeclarative-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtdoc-everywhere-src-6.4.1.tar.xz";
      sha256 = "198gl45c6m1gxn13aic65xgy94in1b1hy255jq6pi44m36brspbn";
      name = "qtdoc-everywhere-src-6.4.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qthttpserver-everywhere-src-6.4.1.tar.xz";
      sha256 = "1xib6q8ji64kq2r5y6qqig0090irjwi25vzpy8528wv5a3i0yxah";
      name = "qthttpserver-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtimageformats-everywhere-src-6.4.1.tar.xz";
      sha256 = "1rjd8mi8z864gqaa849kc4xppbjjr2yddcgahx16z3psn8zfg1ay";
      name = "qtimageformats-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtlanguageserver-everywhere-src-6.4.1.tar.xz";
      sha256 = "1j2xd4r9ngdi5nq35bycxx9jc7bngjlrxa0cs8cjgl7zkj3wsmg3";
      name = "qtlanguageserver-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtlottie-everywhere-src-6.4.1.tar.xz";
      sha256 = "0b59xd5nx4c2mhdl79fzbyz25n8bkdbh8h43l8lp3an15y08bdya";
      name = "qtlottie-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtmultimedia-everywhere-src-6.4.1.tar.xz";
      sha256 = "1bxs1n22yplds2f60h2j25aw9ibhhgprg9np3ybr0q3f08xd91n0";
      name = "qtmultimedia-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtnetworkauth-everywhere-src-6.4.1.tar.xz";
      sha256 = "08kmkpjm34bkbiz54zm4p9mjr9fjzx2kjf0fkhay0lz3iljp0sl3";
      name = "qtnetworkauth-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtpositioning-everywhere-src-6.4.1.tar.xz";
      sha256 = "12yip3awqwcx3fqr8jl64bvp3scvi9pbzyjzk0pm2f6r3kl14qbh";
      name = "qtpositioning-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtquick3d-everywhere-src-6.4.1.tar.xz";
      sha256 = "11881pfia0nwjxsgy2789s01qcvi9x4rhfcckxfzl4819pxw1nx6";
      name = "qtquick3d-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtquick3dphysics-everywhere-src-6.4.1.tar.xz";
      sha256 = "1fxd3d8x0sgwqsvwv61m0kg4pd9gz99gqkgqd3schdhlcwgaim0x";
      name = "qtquick3dphysics-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtquicktimeline-everywhere-src-6.4.1.tar.xz";
      sha256 = "0p6yb3qg9i7774kvwcj8i56ab9vkifi5d92y2w8v9s25g31pspzk";
      name = "qtquicktimeline-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtremoteobjects-everywhere-src-6.4.1.tar.xz";
      sha256 = "1jvsvfj8bdqxfc0vhihgmvglck0zk5nl487kbbjyhkgia1v37m98";
      name = "qtremoteobjects-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtscxml-everywhere-src-6.4.1.tar.xz";
      sha256 = "13mvih36shrjhpp1z3kqlyzgyh35gkx3a12rzh0yff4gmp5y9w6j";
      name = "qtscxml-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtsensors-everywhere-src-6.4.1.tar.xz";
      sha256 = "1qpr6g424dpy2xccfyrkf5v2rszczq5p73lzk79s8g95fl33yzk6";
      name = "qtsensors-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtserialbus-everywhere-src-6.4.1.tar.xz";
      sha256 = "12y4pd87k1y044rfppnmv0zdfmqx42ng0hixhzblr8fbvvwh494g";
      name = "qtserialbus-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtserialport-everywhere-src-6.4.1.tar.xz";
      sha256 = "1yl25cv0ajfjswg8jgkf4jwwsasr5g7sgsc3fb3zsaz6cd8cw2hx";
      name = "qtserialport-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtshadertools-everywhere-src-6.4.1.tar.xz";
      sha256 = "012525kfnnkprgzgncqkzmif3z9k1qa6hfpscbsqg3084s1p9hbb";
      name = "qtshadertools-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtspeech-everywhere-src-6.4.1.tar.xz";
      sha256 = "0jbv6r953r884wfnxrrcvf44xpvc7d8kzjd3lqv4y234748hsrih";
      name = "qtspeech-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtsvg-everywhere-src-6.4.1.tar.xz";
      sha256 = "1rcwrsdq9412qq9ilfs54yjz7ih8a6r8mbwx7y4dnrqmjk2lalsy";
      name = "qtsvg-everywhere-src-6.4.1.tar.xz";
    };
  };
  qttools = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qttools-everywhere-src-6.4.1.tar.xz";
      sha256 = "0cq99c79p90yv3vlb3xbzamgx7qn4s9fb2gdnjyizhh4dcn5c84y";
      name = "qttools-everywhere-src-6.4.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qttranslations-everywhere-src-6.4.1.tar.xz";
      sha256 = "04kal5b3bplylf33kjc8f7kc4x801qj5qrpsjs609ljnsbqwdns4";
      name = "qttranslations-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtvirtualkeyboard-everywhere-src-6.4.1.tar.xz";
      sha256 = "089v5nxfvrglp9ilaayxls8mhdbrq80z38m2agmw147m8d8dspy2";
      name = "qtvirtualkeyboard-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtwayland-everywhere-src-6.4.1.tar.xz";
      sha256 = "1mgjd6qbz0m2kq9bcdn6mnypfjycwdfyna6z7dhj1m61s52id5lw";
      name = "qtwayland-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtwebchannel-everywhere-src-6.4.1.tar.xz";
      sha256 = "1abw58yccjhgwjrry56mih0vnxlg69dc10vfyi8grqy543qikgid";
      name = "qtwebchannel-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtwebengine-everywhere-src-6.4.1.tar.xz";
      sha256 = "10m763yq39jn6k02bqax6mhgbc0bpnmfmxj4wkw5b67ks48w0n9c";
      name = "qtwebengine-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtwebsockets-everywhere-src-6.4.1.tar.xz";
      sha256 = "093ssssws3w1cjacjzp9j80n7b9y7i87yp8ibshshgj0avm8jxsk";
      name = "qtwebsockets-everywhere-src-6.4.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.4.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.1/submodules/qtwebview-everywhere-src-6.4.1.tar.xz";
      sha256 = "15rqka6pyvi33cmizdjfhc2k5ldd1pykmc4nfx826drar6y32a27";
      name = "qtwebview-everywhere-src-6.4.1.tar.xz";
    };
  };
}
