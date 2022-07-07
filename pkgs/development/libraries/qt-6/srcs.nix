# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qt3d-everywhere-src-6.3.1.tar.xz";
      sha256 = "1zpdafqm82hd2bijw20hi1ng81xwihsn9mm7n5ns4gr5zdnvc6cr";
      name = "qt3d-everywhere-src-6.3.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qt5compat-everywhere-src-6.3.1.tar.xz";
      sha256 = "1zbcaswpl79ixcxzj85qzjq73962s4c7316pibwfrskqswmwcgm4";
      name = "qt5compat-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtactiveqt-everywhere-src-6.3.1.tar.xz";
      sha256 = "0axygqjqny6vjwmc5swn80xrcs97bcjwgxsg81f35srxpn9lxdb4";
      name = "qtactiveqt-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtbase-everywhere-src-6.3.1.tar.xz";
      sha256 = "00sfya41ihqb0zwg6wf1kiy02iymj6mk584hhk2c4s94khfl4r0a";
      name = "qtbase-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtcharts-everywhere-src-6.3.1.tar.xz";
      sha256 = "1xvwsabyfln3sih9764xknl2s3w4w069k210kgbh94bj50iwqc7k";
      name = "qtcharts-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtconnectivity-everywhere-src-6.3.1.tar.xz";
      sha256 = "1c4mnrl7fa8j8fmv5zbqak48nylhxpib7vmsbmmbqqcw19qy8p5j";
      name = "qtconnectivity-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtdatavis3d-everywhere-src-6.3.1.tar.xz";
      sha256 = "1wm8iigpml84zfkw3mb2kll0imszc2y19hkcfwq1wbr9w24xda43";
      name = "qtdatavis3d-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtdeclarative-everywhere-src-6.3.1.tar.xz";
      sha256 = "1s268fha3650dn1lqxf8jfa07wxpw09f6p7rjyiwq3w24d0nkrq3";
      name = "qtdeclarative-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtdoc-everywhere-src-6.3.1.tar.xz";
      sha256 = "1qvhv2b9c6mz7r3sdx0l81a2jr9qri17y1y8k3d6qh488fxqrk32";
      name = "qtdoc-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtimageformats-everywhere-src-6.3.1.tar.xz";
      sha256 = "0br1vqgx0hcc2nx32xviic94mvj6fbagrnzskdr7zdmvvyw140xd";
      name = "qtimageformats-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtlanguageserver-everywhere-src-6.3.1.tar.xz";
      sha256 = "1g2azb4mdzh5zp7xc57g8l2a8wfi44wfjm6js88q4mmchyj4f4br";
      name = "qtlanguageserver-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtlottie-everywhere-src-6.3.1.tar.xz";
      sha256 = "1x8wmc6gwmxk92zjcsrbhrbqbfvnk7302ggghld5wk8jk5lsf2vl";
      name = "qtlottie-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtmultimedia-everywhere-src-6.3.1.tar.xz";
      sha256 = "0dkk3lmzi2fs13cnj8q1lpcs6gghj219826gkwnzyd6nmlm280vy";
      name = "qtmultimedia-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtnetworkauth-everywhere-src-6.3.1.tar.xz";
      sha256 = "0apvsb2ip1m3kw8vi9spvf6f6q72ys8vr40rpyysi7shsjwm83yn";
      name = "qtnetworkauth-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtpositioning-everywhere-src-6.3.1.tar.xz";
      sha256 = "0v78wamvdw02kf9rq7m5v24q2g6jmgq4ch0fnfa014p1r978wy06";
      name = "qtpositioning-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtquick3d-everywhere-src-6.3.1.tar.xz";
      sha256 = "0mhj0r6081bjkq3fsr1vh43zn587v9m20mdpnc979h5q8zp6d9rg";
      name = "qtquick3d-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtquicktimeline-everywhere-src-6.3.1.tar.xz";
      sha256 = "1gpb51d8r707sr0dnvbz65d4zwisfdw40s10kximaxwfrvq3r8aq";
      name = "qtquicktimeline-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtremoteobjects-everywhere-src-6.3.1.tar.xz";
      sha256 = "19jcxxxj3q8vnf9cbgrp3q1pvgwsln8n16nk1gg822f6265h6vga";
      name = "qtremoteobjects-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtscxml-everywhere-src-6.3.1.tar.xz";
      sha256 = "06c6dwwx3z26k9ff6nqagg70lws4l1c6drz1yi4z1lb3c56ibg01";
      name = "qtscxml-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtsensors-everywhere-src-6.3.1.tar.xz";
      sha256 = "1k301lgbiw3fiyryfr18k0dq89ls4xgs4n2pffs456msxmchn92b";
      name = "qtsensors-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtserialbus-everywhere-src-6.3.1.tar.xz";
      sha256 = "1lkqv3r66fiddxbg0fv9w6l83adz3y8zq6i4pmd0hnxs0ivkz580";
      name = "qtserialbus-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtserialport-everywhere-src-6.3.1.tar.xz";
      sha256 = "0vk17cjj9jpdkgd8qwb1x0lijg0p2jxdzx4d67hd57brcl7didjf";
      name = "qtserialport-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtshadertools-everywhere-src-6.3.1.tar.xz";
      sha256 = "0nj35s2z5n438q7nqf6bnj3slwz2am3169ck1ixwqa0mjrv73dsr";
      name = "qtshadertools-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtsvg-everywhere-src-6.3.1.tar.xz";
      sha256 = "1xvxz2jfpr1al85rhwss7ji5vkxa812d0b888hry5f7pwqcg86bv";
      name = "qtsvg-everywhere-src-6.3.1.tar.xz";
    };
  };
  qttools = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qttools-everywhere-src-6.3.1.tar.xz";
      sha256 = "1h96w4bzkbd80vr7lh6hnypdlmbzc1y52c2zrqzvkgm3587pa4n4";
      name = "qttools-everywhere-src-6.3.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qttranslations-everywhere-src-6.3.1.tar.xz";
      sha256 = "15yvvxw1vngnjlly6cady05ljamg01qiaqn2vh0xkph855gdbgfp";
      name = "qttranslations-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtvirtualkeyboard-everywhere-src-6.3.1.tar.xz";
      sha256 = "1f62q0gkz21nraaspy1nrg2ygjih5qgq37qns06snnfq0jr8kq2z";
      name = "qtvirtualkeyboard-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtwayland-everywhere-src-6.3.1.tar.xz";
      sha256 = "1w60p1did7awdlzq5k8vnq2ncpskb07cpvz31cbv99bjs6igw53g";
      name = "qtwayland-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtwebchannel-everywhere-src-6.3.1.tar.xz";
      sha256 = "0s16zx3qn3byldvhmsnwijm8rmizk8vpqj7fnwhjg6c67z10m8ma";
      name = "qtwebchannel-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtwebengine-everywhere-src-6.3.1.tar.xz";
      sha256 = "0ivfsqd5c0cxsnssj6z37901cf6a47w50zaqgjiysvcm3ar36ymd";
      name = "qtwebengine-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtwebsockets-everywhere-src-6.3.1.tar.xz";
      sha256 = "06hj0pkdzjicmbiinjp1dk1ziz8cb3fgcwy7a0dxxjvzr680v64z";
      name = "qtwebsockets-everywhere-src-6.3.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.3.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.3/6.3.1/submodules/qtwebview-everywhere-src-6.3.1.tar.xz";
      sha256 = "0f4hx3rqwg5wqnw37nrhcvi2fxshgfx72xmdc416j4gxhra1i6xl";
      name = "qtwebview-everywhere-src-6.3.1.tar.xz";
    };
  };
}
