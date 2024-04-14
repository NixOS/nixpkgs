# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qt3d-everywhere-src-6.7.0.tar.xz";
      sha256 = "0934i5b90hyxk8s58ji7mc062wdsxlvb45y79ygvfcl6psl84fw0";
      name = "qt3d-everywhere-src-6.7.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qt5compat-everywhere-src-6.7.0.tar.xz";
      sha256 = "1x8r9rjkyxhn2fzhj53z7biqd0hxkka5rdp0cc5s9n25hgyx8jcx";
      name = "qt5compat-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtactiveqt-everywhere-src-6.7.0.tar.xz";
      sha256 = "1cyh6h4829pjsklks1agym6gzz7pz2hbydvfqd190izv2fi8a125";
      name = "qtactiveqt-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtbase-everywhere-src-6.7.0.tar.xz";
      sha256 = "0m5jp0rh5965d242s68wdvrxy3x1a6z3p89y8lxhxysj5sgf5chi";
      name = "qtbase-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtcharts-everywhere-src-6.7.0.tar.xz";
      sha256 = "193w5grxndh0gfnyfipn7jdlskfz5b43h97zwbyh3yqvr6c597c9";
      name = "qtcharts-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtconnectivity-everywhere-src-6.7.0.tar.xz";
      sha256 = "0k14f7fqhychxj9j6xwad9yp7wjf7ps5f427l65krxwzq6mddbq7";
      name = "qtconnectivity-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtdatavis3d-everywhere-src-6.7.0.tar.xz";
      sha256 = "1a8v150bva3v9njhma7424jbczjb76l7pgzw61b0qyck326j94ss";
      name = "qtdatavis3d-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtdeclarative-everywhere-src-6.7.0.tar.xz";
      sha256 = "0b4yz9c4lba9p5xgzaymz3a8fwl8s1p8cb0nh6jwrmvlk9bkj32s";
      name = "qtdeclarative-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtdoc-everywhere-src-6.7.0.tar.xz";
      sha256 = "0h4w06rc8xz31iy5g8cmxs9d0p9pd6nxlyjp2k6bbr2dq085w7lr";
      name = "qtdoc-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtgraphs-everywhere-src-6.7.0.tar.xz";
      sha256 = "15clif3warl4hbgdjbpnpfgy4mi2y8hkj5sc4afhzbv2gsbd2dab";
      name = "qtgraphs-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtgrpc-everywhere-src-6.7.0.tar.xz";
      sha256 = "18gsi9sb4v4q2g0ccmf6nkj37vzixaaha3mk882p3qys250b26dp";
      name = "qtgrpc-everywhere-src-6.7.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qthttpserver-everywhere-src-6.7.0.tar.xz";
      sha256 = "1ylvz3cny3g68lqdcy2bqii1820nyaspn28dybp7wlr15f5y7qn2";
      name = "qthttpserver-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtimageformats-everywhere-src-6.7.0.tar.xz";
      sha256 = "19r9q233pwiqqf57khdv1qfnjkqxnzfk7zhnk32i2nnxr1zf0v2i";
      name = "qtimageformats-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtlanguageserver-everywhere-src-6.7.0.tar.xz";
      sha256 = "1z69fqgqbbipwfhlabs0z6axx4br1a1qjk404jnbgxxx58scp7m9";
      name = "qtlanguageserver-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtlocation-everywhere-src-6.7.0.tar.xz";
      sha256 = "0snl7a8fax0771hqaa0g653f0428x7c546zc4vsrinqppik4s15v";
      name = "qtlocation-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtlottie-everywhere-src-6.7.0.tar.xz";
      sha256 = "1vd27g93kjala7849ny3n4nw0xg2j7ba2i682fyhdq4r7kggn3ww";
      name = "qtlottie-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtmultimedia-everywhere-src-6.7.0.tar.xz";
      sha256 = "0w4c0yyzgfhm6vd4qkxllh2cqw5q3giybqf9n2iyckixkvjbm57k";
      name = "qtmultimedia-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtnetworkauth-everywhere-src-6.7.0.tar.xz";
      sha256 = "0iaalz7kpbjzjcrf5nmcw7322mq381s4jakfh8yks8phdxhhaccr";
      name = "qtnetworkauth-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtpositioning-everywhere-src-6.7.0.tar.xz";
      sha256 = "1pwxc2fhwvmq0mwrv9fak3d1bh23b7maxshyp0fs1j167jj1nq0x";
      name = "qtpositioning-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtquick3d-everywhere-src-6.7.0.tar.xz";
      sha256 = "046rgvvf4a37b0anqn1h814231ibw8kxk4yd9yvk7ab57yzl7fcb";
      name = "qtquick3d-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtquick3dphysics-everywhere-src-6.7.0.tar.xz";
      sha256 = "1rh41sadi5l2yypskhwrcjii0llkdq2msh0bgj0g7wq924k5y140";
      name = "qtquick3dphysics-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtquickeffectmaker-everywhere-src-6.7.0.tar.xz";
      sha256 = "1m84pjw4d2gvypgajz21xcl9di1vmswqwb0nd763bjk181kfq3rx";
      name = "qtquickeffectmaker-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtquicktimeline-everywhere-src-6.7.0.tar.xz";
      sha256 = "1gc96jva2nm7a3zv5zwmhrvifjlngngddm3kaivmfpbbdiy6aigb";
      name = "qtquicktimeline-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtremoteobjects-everywhere-src-6.7.0.tar.xz";
      sha256 = "15f6wjszl5mxjrjd8r36l3x3p1nzhgib33bb7743ywf94pb61fm0";
      name = "qtremoteobjects-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtscxml-everywhere-src-6.7.0.tar.xz";
      sha256 = "0z15m5l44asp4masjxmkxqcc4x93v6n8i12qswrzfvbnp2xrfnvj";
      name = "qtscxml-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtsensors-everywhere-src-6.7.0.tar.xz";
      sha256 = "1axwywwgygcri1pfjyaiqa7hd7kivya0gr0q11v4z9ih18h1ac0w";
      name = "qtsensors-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtserialbus-everywhere-src-6.7.0.tar.xz";
      sha256 = "1pbnpfazgpaqzi1sz141sh9sqygibb25crk7byjzhr06hslr70a9";
      name = "qtserialbus-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtserialport-everywhere-src-6.7.0.tar.xz";
      sha256 = "1jc1g46pgjy39vyk7inzx0kx6iziy54kgjkwz8pvmj4wihyjmw5i";
      name = "qtserialport-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtshadertools-everywhere-src-6.7.0.tar.xz";
      sha256 = "1bwqg5gn2nfm61950yhcv9q93qd2fb2cnm77074ia21gqrkzj4ry";
      name = "qtshadertools-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtspeech-everywhere-src-6.7.0.tar.xz";
      sha256 = "048z7lqvpqi4073lx7s83d9kqbfg59banapi7qiw4j3xhfx8wxj4";
      name = "qtspeech-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtsvg-everywhere-src-6.7.0.tar.xz";
      sha256 = "0bcjpwzggrqp2gf9a1xp8g0klh9kn2amnvp2lr9n2ppz107g860m";
      name = "qtsvg-everywhere-src-6.7.0.tar.xz";
    };
  };
  qttools = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qttools-everywhere-src-6.7.0.tar.xz";
      sha256 = "0yzfmfqwn0y534z47yyk71236nnsq0v0kgsw8qiixzl2kqinpnn8";
      name = "qttools-everywhere-src-6.7.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qttranslations-everywhere-src-6.7.0.tar.xz";
      sha256 = "0mjbx9n8fh4xp9r0r4p9ynjy1iirzn3bwlyr3g6vm91c0r3q1z16";
      name = "qttranslations-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtvirtualkeyboard-everywhere-src-6.7.0.tar.xz";
      sha256 = "0snbl1wd5s76c8ab76bsqi3bp94h1isdwavbjm6gc1hvifhv46yn";
      name = "qtvirtualkeyboard-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtwayland-everywhere-src-6.7.0.tar.xz";
      sha256 = "1sks2m2phf841zl0d4sn7krm6f1ppgl7wl9arpc8i8vx47j70d6p";
      name = "qtwayland-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtwebchannel-everywhere-src-6.7.0.tar.xz";
      sha256 = "1zzg49ii59sw64m98phsbhf97kx7nxp7k0ggxazbz0hc9r0bvgr6";
      name = "qtwebchannel-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtwebengine-everywhere-src-6.7.0.tar.xz";
      sha256 = "1pj7q5r8wa49faxijljfnbmzbpmqc7bwcal0mcwz9haxcd1s8nqs";
      name = "qtwebengine-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtwebsockets-everywhere-src-6.7.0.tar.xz";
      sha256 = "0dlp2ck0pkg9say92qism438i5j3ybxs0xf90j7g3k9ndgd7gz2z";
      name = "qtwebsockets-everywhere-src-6.7.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.0/submodules/qtwebview-everywhere-src-6.7.0.tar.xz";
      sha256 = "1yawx8vd7blky5b8mxpby4k1zwgm91jvl98y17xf47yc71qy069n";
      name = "qtwebview-everywhere-src-6.7.0.tar.xz";
    };
  };
}
