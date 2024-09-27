# DO NOT EDIT! This file is generated automatically.
# Command: /home/k900/gh/NixOS/nixpkgs/./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qt3d-everywhere-src-6.7.3.tar.xz";
      sha256 = "155nddckcc94klwsn51s9p8ynk1acg7q9dx99blhq7ch98vqrm25";
      name = "qt3d-everywhere-src-6.7.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qt5compat-everywhere-src-6.7.3.tar.xz";
      sha256 = "1w2k7911n20wdgl3lmxwc7h8sbn7jkjwxz6sl089szmavyinhslb";
      name = "qt5compat-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtactiveqt-everywhere-src-6.7.3.tar.xz";
      sha256 = "03qsszrsv3x2w9v65wnmizyqbs0x13c00zjd7sfgsaxw20p5x11a";
      name = "qtactiveqt-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtbase-everywhere-src-6.7.3.tar.xz";
      sha256 = "15rhv8irwpgxs0pgqsn5dy9ndz6n3vfyv7iccdvaq1aj0nmvkjwc";
      name = "qtbase-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtcharts-everywhere-src-6.7.3.tar.xz";
      sha256 = "0n9n4gj86g86yqkgws12aw2p6d94lmx6y19qki5gmg76a2jn7sh7";
      name = "qtcharts-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtconnectivity-everywhere-src-6.7.3.tar.xz";
      sha256 = "1igwnbjhdwmaw1x4v0gx9wv4h4a5h9f9rv9m9dyi0ybv14prpyc0";
      name = "qtconnectivity-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtdatavis3d-everywhere-src-6.7.3.tar.xz";
      sha256 = "108x4hafvrc4jpmmx6lcf7mnns7vkgz0004b6qkw5bzq36apdwp1";
      name = "qtdatavis3d-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtdeclarative-everywhere-src-6.7.3.tar.xz";
      sha256 = "0xcq1dhws5k1sdf8iwxc2j2s45171rhjckfla17brxdb87j70ywk";
      name = "qtdeclarative-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtdoc-everywhere-src-6.7.3.tar.xz";
      sha256 = "0113rrsrcaw5l425xv96z081idjpav2iprg1834pxfqk3wk2l3ak";
      name = "qtdoc-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtgraphs-everywhere-src-6.7.3.tar.xz";
      sha256 = "13vcx0fkx9vyvjysnj0n805x13ir1srbzlg1jha8h56ccg6dw2f3";
      name = "qtgraphs-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtgrpc-everywhere-src-6.7.3.tar.xz";
      sha256 = "1py6h4g5zhqpm99bhxk12paw675a4c6dl95s6nwkvg1y2vaavapf";
      name = "qtgrpc-everywhere-src-6.7.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qthttpserver-everywhere-src-6.7.3.tar.xz";
      sha256 = "1zyyyj9q0yy5gh28yqgc0nwhgdvg0qbwkag9bd566srbwp3if8vz";
      name = "qthttpserver-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtimageformats-everywhere-src-6.7.3.tar.xz";
      sha256 = "0ls76bxl3xhy7hyzw53vj8q3h0llsbm9dpb86wvw6m0n11283mcz";
      name = "qtimageformats-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtlanguageserver-everywhere-src-6.7.3.tar.xz";
      sha256 = "13yzz6qnpkah9s89xlqiszzkbw1j6c1a2vzwkgjdj0w589r3hvf5";
      name = "qtlanguageserver-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtlocation-everywhere-src-6.7.3.tar.xz";
      sha256 = "1657scmrkyhm31fgvgpjlqd053gb7bcywra4qvlgg3h4rpfxg7sn";
      name = "qtlocation-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtlottie-everywhere-src-6.7.3.tar.xz";
      sha256 = "03c3s6alabqqqhi8cx8rnkr3gx7h8rcf2wn8iy9n7hbsfrvix39r";
      name = "qtlottie-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtmultimedia-everywhere-src-6.7.3.tar.xz";
      sha256 = "00vkazz4mcz5n2hdh10y9mh0fi2kygai009vi69m4hwjwnw2hk9h";
      name = "qtmultimedia-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtnetworkauth-everywhere-src-6.7.3.tar.xz";
      sha256 = "1dqk9983cjf3kiprk053xn3np2c25044dlfdrzs5d742x2jpb6kb";
      name = "qtnetworkauth-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtpositioning-everywhere-src-6.7.3.tar.xz";
      sha256 = "0736qsf7k3dqdm9gd7xc0l368h45jgzh4nzz72wizj9489sp6w6s";
      name = "qtpositioning-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtquick3d-everywhere-src-6.7.3.tar.xz";
      sha256 = "0mwrlz9ji0ivnxz44m9xhhsk7lngxjnmid420s359vs21msik6ni";
      name = "qtquick3d-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtquick3dphysics-everywhere-src-6.7.3.tar.xz";
      sha256 = "1wyqi6z0g2pi0wj288ssjj0awn8jpi9rqa8bi510s9vr625w8pdl";
      name = "qtquick3dphysics-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtquickeffectmaker-everywhere-src-6.7.3.tar.xz";
      sha256 = "15if8ansjc1nkpaf6ldyydb47grgv079pm15ljn0ykf35ldzv2sq";
      name = "qtquickeffectmaker-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtquicktimeline-everywhere-src-6.7.3.tar.xz";
      sha256 = "00n90camzs7c3s61id58466sypc83w0101wrnw0xwlaci1kld45p";
      name = "qtquicktimeline-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtremoteobjects-everywhere-src-6.7.3.tar.xz";
      sha256 = "1lciziv5qvnxich39j0q46v3pkn83yy1jkm2q3d10k5672lqmh4r";
      name = "qtremoteobjects-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtscxml-everywhere-src-6.7.3.tar.xz";
      sha256 = "18zdgq3sapkh6jsnfhl0xm0r8ydbg7kxwr70b7szpdmg1pmyp3v0";
      name = "qtscxml-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtsensors-everywhere-src-6.7.3.tar.xz";
      sha256 = "1z68yfjljv7bi49kna4a7yz6javw9bqdw0jr30zmzvb2ldfqsfn0";
      name = "qtsensors-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtserialbus-everywhere-src-6.7.3.tar.xz";
      sha256 = "0xk218y1cm9icdzb4dn9nvszr9n22anmf2iz72vhhy42gaf2xn2m";
      name = "qtserialbus-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtserialport-everywhere-src-6.7.3.tar.xz";
      sha256 = "1w26n5nw8fv9cq258xm0p7niisbig5ky83njm3nwjfcvh3p5iynl";
      name = "qtserialport-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtshadertools-everywhere-src-6.7.3.tar.xz";
      sha256 = "1589ij1aarr0i6cfbdxg8yxvljs52599g39d98sxmnvxiiwi5rbl";
      name = "qtshadertools-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtspeech-everywhere-src-6.7.3.tar.xz";
      sha256 = "04h998pshs2bzm3a0bvmkq2an2yhgfrap22k3lvprx3f3gsgn2gn";
      name = "qtspeech-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtsvg-everywhere-src-6.7.3.tar.xz";
      sha256 = "0sx0xm6hcjhjhrmswycrgwvdjk6mymkindmw2bb7mq5i3yvjq520";
      name = "qtsvg-everywhere-src-6.7.3.tar.xz";
    };
  };
  qttools = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qttools-everywhere-src-6.7.3.tar.xz";
      sha256 = "0gr06dr3dd334mswrjdxp27dhpdbpjvk03hipafsrncwc7gvffzh";
      name = "qttools-everywhere-src-6.7.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qttranslations-everywhere-src-6.7.3.tar.xz";
      sha256 = "1j3dklf0gvzpnl6zw254fv7wy3iyypbbcsfkwjsrnfq4mjn65iyw";
      name = "qttranslations-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtvirtualkeyboard-everywhere-src-6.7.3.tar.xz";
      sha256 = "1n932jgj97ili5chhfrscqvhdaz0na5yla3xljnlih0jw82231qs";
      name = "qtvirtualkeyboard-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtwayland-everywhere-src-6.7.3.tar.xz";
      sha256 = "1ddjf9lrlx8cp0699sq8vc8fx44nvz9daxq5qazh7x98nv7cf9p3";
      name = "qtwayland-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtwebchannel-everywhere-src-6.7.3.tar.xz";
      sha256 = "1f3lak91fvlncgs43dcgkgjg25f9449d2pvbsh33m6xhdpg3yqqm";
      name = "qtwebchannel-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtwebengine-everywhere-src-6.7.3.tar.xz";
      sha256 = "1ns6v24jarjlvd1b3nh4x3sp6y38ag62dsh7x6f5dp40pff1aay2";
      name = "qtwebengine-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtwebsockets-everywhere-src-6.7.3.tar.xz";
      sha256 = "03lrqphvn0bwrma8rjqb8x7giqgk24gdgl9v7syaas7fnxyh00xs";
      name = "qtwebsockets-everywhere-src-6.7.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.7.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.3/submodules/qtwebview-everywhere-src-6.7.3.tar.xz";
      sha256 = "0bdr0m8453difqwd8gvgqsd4df4j8lnlbi44cdazwhx28kzfi2kh";
      name = "qtwebview-everywhere-src-6.7.3.tar.xz";
    };
  };
}
