# DO NOT EDIT! This file is generated automatically.
# Command: /home/k900/gh/NixOS/nixpkgs/./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qt3d-everywhere-src-6.7.2.tar.xz";
      sha256 = "1pwagjicvqc7lbypkw7wvjznndyzqm2ihisqdqc36ccp0kcqgh4b";
      name = "qt3d-everywhere-src-6.7.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qt5compat-everywhere-src-6.7.2.tar.xz";
      sha256 = "00y071p09v91ascxg3llc0yfbx7xs24smcgxckdrnkgwkqcba9l8";
      name = "qt5compat-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtactiveqt-everywhere-src-6.7.2.tar.xz";
      sha256 = "1y02pyb2bz9wf5jmf2kh20wqq2vmq8afmgrs0pvhgfvyrs8b7an0";
      name = "qtactiveqt-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtbase-everywhere-src-6.7.2.tar.xz";
      sha256 = "16bmfrjfxjajs6sqg1383ihhfwwf69ihkpnpvsajh5pv21g2mwn5";
      name = "qtbase-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtcharts-everywhere-src-6.7.2.tar.xz";
      sha256 = "1nlv4z2rvhrn1f1f7n6qdag7lmkpl3idnj6ph572qzwb8lvs9xh0";
      name = "qtcharts-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtconnectivity-everywhere-src-6.7.2.tar.xz";
      sha256 = "1s08djgzhh5p9ij0hxbrrcx9n7r7f0ba6pr9793mdsgh8ar23lwf";
      name = "qtconnectivity-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtdatavis3d-everywhere-src-6.7.2.tar.xz";
      sha256 = "0lsfd737zi8517scys3xj4c9l505vvkdg3n6dw89bdfyjmywisy0";
      name = "qtdatavis3d-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtdeclarative-everywhere-src-6.7.2.tar.xz";
      sha256 = "16drp7yjsm50cvsyww9xk15hzf2csax02vpbv0jx8hlcmyhwnaac";
      name = "qtdeclarative-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtdoc-everywhere-src-6.7.2.tar.xz";
      sha256 = "0vbmhx2rbfbxgzz1ipa185wvnm08a43sdr47y9jn1ivdnrn4bhd0";
      name = "qtdoc-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtgraphs-everywhere-src-6.7.2.tar.xz";
      sha256 = "0046293800if5ca04r40wsa4gxh8r5q6c863yrx3cmjadqk3m0fq";
      name = "qtgraphs-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtgrpc-everywhere-src-6.7.2.tar.xz";
      sha256 = "0zp1l9vf0p78f53mhirs4crw6cjy6fmv26n7nndyrk8a0hz8b7wd";
      name = "qtgrpc-everywhere-src-6.7.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qthttpserver-everywhere-src-6.7.2.tar.xz";
      sha256 = "11lbfx08yl725w4n8dmvviscixvfkpzx8ijhy74gx0waz6sbjlq3";
      name = "qthttpserver-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtimageformats-everywhere-src-6.7.2.tar.xz";
      sha256 = "1mp5bi45gcmsds0g2xfjd1mklrijbwfv0hx4s1md2rxfbxwdi8g1";
      name = "qtimageformats-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtlanguageserver-everywhere-src-6.7.2.tar.xz";
      sha256 = "14hs20738d2ljfb5la8p0lip7qranjnrwl5fwdhs1zs4a5jzwndn";
      name = "qtlanguageserver-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtlocation-everywhere-src-6.7.2.tar.xz";
      sha256 = "0pa8ibw490p3433ysni73f0gpz7gvxyl2abh3ygvd28ipxcdlcpj";
      name = "qtlocation-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtlottie-everywhere-src-6.7.2.tar.xz";
      sha256 = "03piwc7p0lgqm73rx2kf5ckh986nv9dkssfl47js8lnkb29vrbyr";
      name = "qtlottie-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtmultimedia-everywhere-src-6.7.2.tar.xz";
      sha256 = "1lsiarvag8lr4a1apa466xz56b1znjncy8wz5hyiv6nbb88kby4f";
      name = "qtmultimedia-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtnetworkauth-everywhere-src-6.7.2.tar.xz";
      sha256 = "0w7l5lhhxhg9x1rd66727gwkpzi6l7wmyc0c4qrfp2g5rx7q42bz";
      name = "qtnetworkauth-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtpositioning-everywhere-src-6.7.2.tar.xz";
      sha256 = "073v10z1axmqydrvdka9g69wr117kzhvci9sjr110swgmbq0j002";
      name = "qtpositioning-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtquick3d-everywhere-src-6.7.2.tar.xz";
      sha256 = "0w2js64s1wg86dblqmmy9cyjz2x96f9qbk4674xjsbnsqspgk3xv";
      name = "qtquick3d-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtquick3dphysics-everywhere-src-6.7.2.tar.xz";
      sha256 = "0h21dq5yplqizyk43agfw7yzyjfcs3d8bl7jq6n07g2fnjw91izz";
      name = "qtquick3dphysics-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtquickeffectmaker-everywhere-src-6.7.2.tar.xz";
      sha256 = "0vbmgdqlwihi379z1yr8ci09jxr93jrkgd8ripr2jb680z72c3rv";
      name = "qtquickeffectmaker-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtquicktimeline-everywhere-src-6.7.2.tar.xz";
      sha256 = "1sqr0xmiz33wfl5db24chq3gsbs0p17ylbin23gcx5gh3jhdxv91";
      name = "qtquicktimeline-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtremoteobjects-everywhere-src-6.7.2.tar.xz";
      sha256 = "10vlkg5v5hc8fwiw9x06d84z6cs4i5kxm652si3lwvvxma0np40b";
      name = "qtremoteobjects-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtscxml-everywhere-src-6.7.2.tar.xz";
      sha256 = "0vy80npai5ikwlf0ghxf5xj8vq1hi3cdjgddjas2g3yl0qszkv10";
      name = "qtscxml-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtsensors-everywhere-src-6.7.2.tar.xz";
      sha256 = "0ndvwra9bssfqw32bk5mbj3zdqgi9zshm0gd0bfd8vn5hz3xxlga";
      name = "qtsensors-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtserialbus-everywhere-src-6.7.2.tar.xz";
      sha256 = "0asb6xnp6gnn41bivirld1llhb2zmbgidianv7blcms5kfliqr37";
      name = "qtserialbus-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtserialport-everywhere-src-6.7.2.tar.xz";
      sha256 = "1z5lsgdl4g48fr2kcp7zznv5jyv42xmd4qn6rrxikd8w2v8lrhr1";
      name = "qtserialport-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtshadertools-everywhere-src-6.7.2.tar.xz";
      sha256 = "1hbw5xz12frydk787rl6cgfxm2bxlzkxiwcxjjmgq04cmk039ypd";
      name = "qtshadertools-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtspeech-everywhere-src-6.7.2.tar.xz";
      sha256 = "1khl90m6jd2zg0r0fncdz3r1w2l96vwp6jihpq9rgr730ja7d36c";
      name = "qtspeech-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtsvg-everywhere-src-6.7.2.tar.xz";
      sha256 = "00ggr84l1h8did6ivprv343rwwcl7j2bbbilxqzmiqsvlf3143gv";
      name = "qtsvg-everywhere-src-6.7.2.tar.xz";
    };
  };
  qttools = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qttools-everywhere-src-6.7.2.tar.xz";
      sha256 = "0ajbma9lbrb0d048bvg2xl74m833ddv2b9684r3hjcr53fnmbs2q";
      name = "qttools-everywhere-src-6.7.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qttranslations-everywhere-src-6.7.2.tar.xz";
      sha256 = "1a9cb1br3wqn0rshkgj21hba3r7jx8dbavc3ayfjgdy1bl5phicq";
      name = "qttranslations-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtvirtualkeyboard-everywhere-src-6.7.2.tar.xz";
      sha256 = "03qqrs0nv6bhnm0ps54inw43xgnfx3vdq8mqq5wzyq09basn81ij";
      name = "qtvirtualkeyboard-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtwayland-everywhere-src-6.7.2.tar.xz";
      sha256 = "0nwa59g1wk7fkym837pkw312abjb376gx44rpd5d8jv4vphmg852";
      name = "qtwayland-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtwebchannel-everywhere-src-6.7.2.tar.xz";
      sha256 = "072hniyxavz2jjkzh7mrz4g67zf0cngvp4xgdradxrqhgdh9cpdc";
      name = "qtwebchannel-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtwebengine-everywhere-src-6.7.2.tar.xz";
      sha256 = "1lgz0mj9lw4ii1c8nkbr0ll02xzx8i6n7wvvn21f72sdb5smhxf7";
      name = "qtwebengine-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtwebsockets-everywhere-src-6.7.2.tar.xz";
      sha256 = "0pr13p6inlh2i79yc567w8dp446rh9xvfakq5diwis4wxkv4mpjv";
      name = "qtwebsockets-everywhere-src-6.7.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.7.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.7/6.7.2/submodules/qtwebview-everywhere-src-6.7.2.tar.xz";
      sha256 = "1zp44kfrks0grc1l6f3ayvfmw45zmhal0pfrzjdw7znl0dlhkqac";
      name = "qtwebview-everywhere-src-6.7.2.tar.xz";
    };
  };
}
