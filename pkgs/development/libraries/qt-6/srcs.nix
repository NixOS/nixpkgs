# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qt3d-everywhere-src-6.11.3.tar.xz";
      sha256 = "0l7vsadhslwx8r6g6lpfn1ypw3ixfqgvsg5i6k6hd75jw2abqqwg";
      name = "qt3d-everywhere-src-6.11.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qt5compat-everywhere-src-6.11.3.tar.xz";
      sha256 = "05k58gz7kfizyysys5jbgsr2y0x6m84kf33mnran7r3x85kq169f";
      name = "qt5compat-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtactiveqt-everywhere-src-6.11.3.tar.xz";
      sha256 = "0bkaggqmkp8sqlibh6bmb00j9c51np78k9hynlz0z1qxjyid206v";
      name = "qtactiveqt-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtbase-everywhere-src-6.11.3.tar.xz";
      sha256 = "13wg5z37nm6ana0kgi83d4f191m3v9a47r3a8ifmm54lnl80gpj6";
      name = "qtbase-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtcanvaspainter-everywhere-src-6.11.3.tar.xz";
      sha256 = "12j73ss1qyci96gmnqc43ibdpr3bnqr32b34vn1bk50cwqig5w70";
      name = "qtcanvaspainter-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtcharts-everywhere-src-6.11.3.tar.xz";
      sha256 = "0037dp8d1371bd3chbrdkfzsab25x4y9z9fipkdv1s1ndy7d2l8x";
      name = "qtcharts-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtconnectivity-everywhere-src-6.11.3.tar.xz";
      sha256 = "1w7yzq75ys8a28lnckaad2xdm98z4bzja8b1nnz7cds11ys9ca6x";
      name = "qtconnectivity-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtdatavis3d-everywhere-src-6.11.3.tar.xz";
      sha256 = "0pj99b2a1zsyic7z2z3rmpdz31c4i3v17s152mr54yvhzw1j8w9y";
      name = "qtdatavis3d-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtdeclarative-everywhere-src-6.11.3.tar.xz";
      sha256 = "1dcwfpsh015zidqb2ndbammwsi7yippswi393q5vpqral0lb6vbd";
      name = "qtdeclarative-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtdoc-everywhere-src-6.11.3.tar.xz";
      sha256 = "0bjyxfhw5cj1sxw72c7j3pbihfaxdwxajqbmh8jkamj8nia35fz9";
      name = "qtdoc-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtgraphs-everywhere-src-6.11.3.tar.xz";
      sha256 = "0smvhkbv32hm4bzajc7i38z9gbh6sjjnwyhjq2ij404kcifb8x2f";
      name = "qtgraphs-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtgrpc-everywhere-src-6.11.3.tar.xz";
      sha256 = "1xl5hissy6srh95g4jh0nc7w2i6pr6fgyymdrqlx6w8m6434g60p";
      name = "qtgrpc-everywhere-src-6.11.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qthttpserver-everywhere-src-6.11.3.tar.xz";
      sha256 = "0zix6a41gxhpsyq1xg920fgvy43n7hxlmwzgsnm8zry1m853vqgf";
      name = "qthttpserver-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtimageformats-everywhere-src-6.11.3.tar.xz";
      sha256 = "04v27qr2shf1wvn386vrq9mq3fxbq751qk9r41hkgidvgaf94n97";
      name = "qtimageformats-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtlanguageserver-everywhere-src-6.11.3.tar.xz";
      sha256 = "03ynm353x244pysri7ndr60d03lvs2ymgg9bcnvpw583ah5k3x34";
      name = "qtlanguageserver-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtlocation-everywhere-src-6.11.3.tar.xz";
      sha256 = "03jjfnrz2aks282ccd9964dx5qq17xr8lipch0h09m20nmmzl4sl";
      name = "qtlocation-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtlottie-everywhere-src-6.11.3.tar.xz";
      sha256 = "172vanjlj29s12idmzqs8yil9mzc4k4fv848a765mvp0fz4mk7jz";
      name = "qtlottie-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtmultimedia-everywhere-src-6.11.3.tar.xz";
      sha256 = "1rl8f90zq32nqkq5vhdf1zna327rvx52lxki71n6hdyippljs5rx";
      name = "qtmultimedia-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtnetworkauth-everywhere-src-6.11.3.tar.xz";
      sha256 = "1hvdzd4hdrzi7570wajlr7bmkcm95c2xm4ns8vka8sc22n12y7m4";
      name = "qtnetworkauth-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtopenapi-everywhere-src-6.11.3.tar.xz";
      sha256 = "0hd0dbp2b1959xggqngckpw106xaajr858rzpwrp3kvmkrj6zz63";
      name = "qtopenapi-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtpositioning-everywhere-src-6.11.3.tar.xz";
      sha256 = "18gcfdf6xrxj9shwdv1l3kk1k4zcc221g5lfdr3n2wib86y9b1m3";
      name = "qtpositioning-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtquick3d-everywhere-src-6.11.3.tar.xz";
      sha256 = "15ncmh7fgv50qsdk5hqzbk0ffx2qiv6ckdz9r3925vnkxa8j8pf0";
      name = "qtquick3d-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtquick3dphysics-everywhere-src-6.11.3.tar.xz";
      sha256 = "0gcjd471lv9knjx457zh5jx2cw64xfn7drx6zq8vxpbad60n2lzd";
      name = "qtquick3dphysics-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtquickeffectmaker-everywhere-src-6.11.3.tar.xz";
      sha256 = "0pxvpg87l0g3k8y4zzyz3a56293kxz342d5vd5viz0gk95mgwp3l";
      name = "qtquickeffectmaker-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtquicktimeline-everywhere-src-6.11.3.tar.xz";
      sha256 = "14n687llw4jfc30p56nvbnizwx7qisn4rzsdziw66gyili9j9rg0";
      name = "qtquicktimeline-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtremoteobjects-everywhere-src-6.11.3.tar.xz";
      sha256 = "10s2zmdhrfigwdimq33kwnnc2whizhlr0fc2c6wn3bhlc6mfh1vy";
      name = "qtremoteobjects-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtscxml-everywhere-src-6.11.3.tar.xz";
      sha256 = "07q8sbgd0mz3afqz4aklgvf4hhy7fn3vxzwrbilhk5jdsa17g7fq";
      name = "qtscxml-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtsensors-everywhere-src-6.11.3.tar.xz";
      sha256 = "1d5fyxqkhpiz0g6afmisy5yg3h8yr79sr03ha83sdpd378s647c4";
      name = "qtsensors-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtserialbus-everywhere-src-6.11.3.tar.xz";
      sha256 = "17jnhjr909ld4yasz31sryzk0q2jwb7azaarghnpyymi443sjjlk";
      name = "qtserialbus-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtserialport-everywhere-src-6.11.3.tar.xz";
      sha256 = "08hpc0k68jb1c10x0k4sq8n5r27vm6djqzqgk0dwww70mh7gp6xh";
      name = "qtserialport-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtshadertools-everywhere-src-6.11.3.tar.xz";
      sha256 = "06w0im9kvsiljzxpxyjw3b9af0x4n0ihdlpl0nxyq7n7br17jq6q";
      name = "qtshadertools-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtspeech-everywhere-src-6.11.3.tar.xz";
      sha256 = "132p46d10rj4pindpk1qx9i92p8ndjzyv896b742s37j45vv7bfg";
      name = "qtspeech-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtsvg-everywhere-src-6.11.3.tar.xz";
      sha256 = "08vil24l3ka6k74x69dcs0csxw6z7wk15p9fm8z1rnd2nnj6zpwv";
      name = "qtsvg-everywhere-src-6.11.3.tar.xz";
    };
  };
  qttasktree = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qttasktree-everywhere-src-6.11.3.tar.xz";
      sha256 = "01fvxjvhj0bzhgb9x7zgpjz6z709xpdvshic43m642zasf1fpqhh";
      name = "qttasktree-everywhere-src-6.11.3.tar.xz";
    };
  };
  qttools = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qttools-everywhere-src-6.11.3.tar.xz";
      sha256 = "1v31dkyncfkhgscd1w8gapi0x4r511f6mrjccka3dyjkwsgafk2j";
      name = "qttools-everywhere-src-6.11.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qttranslations-everywhere-src-6.11.3.tar.xz";
      sha256 = "1wlhwa2785hjgzkb80sds0whkhviswy4m9fpx9g6flqyp5kk17j9";
      name = "qttranslations-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtvirtualkeyboard-everywhere-src-6.11.3.tar.xz";
      sha256 = "0y3lpfn33sipbx0drvh933vdb142qzpq29w6bhidii2ww33a83kw";
      name = "qtvirtualkeyboard-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtwayland-everywhere-src-6.11.3.tar.xz";
      sha256 = "15vcdwv8avqs0s6kard2lzcz55mfakf1ibyz88n20xbxdvmqaqbz";
      name = "qtwayland-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtwebchannel-everywhere-src-6.11.3.tar.xz";
      sha256 = "06phzbzylw00s9jqrh3p0k2wn5gyb6a5xyyl9zfs182cj3121w8x";
      name = "qtwebchannel-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtwebengine-everywhere-src-6.11.3.tar.xz";
      sha256 = "1jj3kwpsw74j6q1475c2ri7cds7yrc92qzsmcwg5g43djys02isg";
      name = "qtwebengine-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtwebsockets-everywhere-src-6.11.3.tar.xz";
      sha256 = "0fwq2q83y0sm96ldziyhlg908kf6q80h420gzr2a6rzc6z69mcqr";
      name = "qtwebsockets-everywhere-src-6.11.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.11.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.3/submodules/qtwebview-everywhere-src-6.11.3.tar.xz";
      sha256 = "1dw9fbv8vqf0vzqsx9n6qhxg54lg1a19njrvkkilwnagmw908dpa";
      name = "qtwebview-everywhere-src-6.11.3.tar.xz";
    };
  };
}
