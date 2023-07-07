# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qt3d-everywhere-src-6.5.1.tar.xz";
      sha256 = "16v875hv58f1cnb76c8pd63v44fncfdrv29b008bamxs23lf2m3y";
      name = "qt3d-everywhere-src-6.5.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qt5compat-everywhere-src-6.5.1.tar.xz";
      sha256 = "10zvah04mnyg5apkwq015kxs03y467naicxy8ljfzazgbwljp6df";
      name = "qt5compat-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtactiveqt-everywhere-src-6.5.1.tar.xz";
      sha256 = "0yii7ihvzncwqhrb1635my5arr6lymr2d3wnwpcn42b7l6krsk6d";
      name = "qtactiveqt-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtbase-everywhere-src-6.5.1.tar.xz";
      sha256 = "1vdzxrcfhn6ym7p8jzr3xxx1r4r435fx461lwfgii8838cgzlmnv";
      name = "qtbase-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtcharts-everywhere-src-6.5.1.tar.xz";
      sha256 = "0xfgj970ip0fn2gxrsilg1gvq4w2849vs6gysn0qhnz7qw7m0nxi";
      name = "qtcharts-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtconnectivity-everywhere-src-6.5.1.tar.xz";
      sha256 = "0yl2i4qdmvdzspnr0jpf031gd2cndkx4hppy5sdjppy4g2dlrmrg";
      name = "qtconnectivity-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtdatavis3d-everywhere-src-6.5.1.tar.xz";
      sha256 = "0cx3bmbwg0y99495zp1gafs4bfn75dbf6r6dfgy1ii9i66y2lcsj";
      name = "qtdatavis3d-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtdeclarative-everywhere-src-6.5.1.tar.xz";
      sha256 = "0yff5nbcspl3w3231wvgvac38q0lskxx1l2wm1lx2raac7wlh490";
      name = "qtdeclarative-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtdoc-everywhere-src-6.5.1.tar.xz";
      sha256 = "0c9ckm7rcp3vi7qipzqyqpar2f5l426s8vgdz71q1ccx432a0kj1";
      name = "qtdoc-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtgrpc-everywhere-src-6.5.1.tar.xz";
      sha256 = "1r27m7c1ab1gk2hzi4d9mpvk1kc5zypx6d6q9wa7kv26d4d2vgls";
      name = "qtgrpc-everywhere-src-6.5.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qthttpserver-everywhere-src-6.5.1.tar.xz";
      sha256 = "0z7wrvfln7mr7n1i1pijx36c6wi66dm91mdir5f8gqk15i84zpj7";
      name = "qthttpserver-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtimageformats-everywhere-src-6.5.1.tar.xz";
      sha256 = "1daxijk9mb2gb65pxjdqw4r5vjs3vi20d4lixq6mh0xdk717yzw9";
      name = "qtimageformats-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtlanguageserver-everywhere-src-6.5.1.tar.xz";
      sha256 = "1j9bhd4k30ana08nppqqll6v5nxr9dzxqxsh12i2cihjr9mcr9lr";
      name = "qtlanguageserver-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtlocation-everywhere-src-6.5.1.tar.xz";
      sha256 = "1x0j6r0gll469aq75viyyyw1gfl180rcyq0h83z35664jzx1i2mn";
      name = "qtlocation-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtlottie-everywhere-src-6.5.1.tar.xz";
      sha256 = "10bbq952iv3f2v42nqirld0qy363g03zdq6hlh1lfcbmgc8gif0h";
      name = "qtlottie-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtmultimedia-everywhere-src-6.5.1.tar.xz";
      sha256 = "1k71chjdh66yv13li38ig507wpsr7cn87nqkvcfxmkf8w5hca7qb";
      name = "qtmultimedia-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtnetworkauth-everywhere-src-6.5.1.tar.xz";
      sha256 = "18viv41qazcbix9l21g5vz1r6zp6mxnbl2c2j3ip1yln7rmbac57";
      name = "qtnetworkauth-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtpositioning-everywhere-src-6.5.1.tar.xz";
      sha256 = "08m41rx1yd28dr53pfrdfvgkmnszqyax88jhqczcb048w50gjg05";
      name = "qtpositioning-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtquick3d-everywhere-src-6.5.1.tar.xz";
      sha256 = "07ncn3gl3yvdq8ly3rn7693lzq0slghmw9ljq119s4bbsnk2ddji";
      name = "qtquick3d-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtquick3dphysics-everywhere-src-6.5.1.tar.xz";
      sha256 = "1j0kfqdwx8x7bagw8qjkywsd2fzih2yp36vza2hil56m35s8ibcl";
      name = "qtquick3dphysics-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtquickeffectmaker-everywhere-src-6.5.1.tar.xz";
      sha256 = "18lhvf9mlprmg0jba9biciscns12zvwr5jj81kkvv0mv8h3yrg2i";
      name = "qtquickeffectmaker-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtquicktimeline-everywhere-src-6.5.1.tar.xz";
      sha256 = "0lfm997p5x5nn4zlz2p1djd3757b0m00347xkfy9n6y5fsidny8h";
      name = "qtquicktimeline-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtremoteobjects-everywhere-src-6.5.1.tar.xz";
      sha256 = "16v2qzn5lf5bxrdff4fr624x5n262qvhinrk0vfmcdvrb2plgkvq";
      name = "qtremoteobjects-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtscxml-everywhere-src-6.5.1.tar.xz";
      sha256 = "0xr4005b640r1h7nbfmgjban9mihxgm4sfqizw30xhsjpg4a6ghw";
      name = "qtscxml-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtsensors-everywhere-src-6.5.1.tar.xz";
      sha256 = "19dbci4487anpkm85n1yly1mm5zx1f5dgx08v5ar5462f61wlnn9";
      name = "qtsensors-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtserialbus-everywhere-src-6.5.1.tar.xz";
      sha256 = "0zqmbqnaf8ln6kdf5nc9k4q618d7jd4dmc2gsmgcf2mz55w9dzyv";
      name = "qtserialbus-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtserialport-everywhere-src-6.5.1.tar.xz";
      sha256 = "19ijnjy5bqv7g74q2ax4pvmggphpccckszxilj0vkqnl8q34smf3";
      name = "qtserialport-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtshadertools-everywhere-src-6.5.1.tar.xz";
      sha256 = "0ljhysyiwxawws0481hyk1xbycc21jg6gq5fsn8yyi2rhdhng075";
      name = "qtshadertools-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtspeech-everywhere-src-6.5.1.tar.xz";
      sha256 = "1djp6ijjvl94zajbvgz80xnzd2fpkq8fnnpxnq9jg5jny6jhn4k7";
      name = "qtspeech-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtsvg-everywhere-src-6.5.1.tar.xz";
      sha256 = "1vq8jvz13hp9nj9r77f0nx7nq3pciy4sk1j6d2dzbw243m4jk3fm";
      name = "qtsvg-everywhere-src-6.5.1.tar.xz";
    };
  };
  qttools = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qttools-everywhere-src-6.5.1.tar.xz";
      sha256 = "0a93xg65z19bldwhc77x87khjwkx3hs01z1gjdznza5jhjgdyi2p";
      name = "qttools-everywhere-src-6.5.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qttranslations-everywhere-src-6.5.1.tar.xz";
      sha256 = "16ylh1hf7r4g8s0h6wgkngwy1p75qnq6byz1q14wwzk3q8s2qzjj";
      name = "qttranslations-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtvirtualkeyboard-everywhere-src-6.5.1.tar.xz";
      sha256 = "1h9whvpdy37vazl095qqvsl8d2b298v2i25fsvr04x9ns3b47cl9";
      name = "qtvirtualkeyboard-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtwayland-everywhere-src-6.5.1.tar.xz";
      sha256 = "0kcp1adgszcrwv89f2m3rp2ldbrbnb7prkr8065w5j9ik2hiw7vw";
      name = "qtwayland-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtwebchannel-everywhere-src-6.5.1.tar.xz";
      sha256 = "0jpc231gmgy540x9im8ld1fjmxqjaw1c40r6d2g5gxrpwxkl6drb";
      name = "qtwebchannel-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtwebengine-everywhere-src-6.5.1.tar.xz";
      sha256 = "0clcxkybgn5ny22rbdckxczqsf5gc3f55q7r02l5q7q6biqbs61g";
      name = "qtwebengine-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtwebsockets-everywhere-src-6.5.1.tar.xz";
      sha256 = "06fsc42x571af78rlx8ah7i9nqc9qnzqvd1mmrx12xd6a2r6d3vb";
      name = "qtwebsockets-everywhere-src-6.5.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.1/submodules/qtwebview-everywhere-src-6.5.1.tar.xz";
      sha256 = "0r1six7k9nz1n64c8ff1j24x2dfrr931aiwygpsf36bim27bdbvb";
      name = "qtwebview-everywhere-src-6.5.1.tar.xz";
    };
  };
}
