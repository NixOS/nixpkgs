# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qt3d-everywhere-src-6.5.0.tar.xz";
      sha256 = "05h84cdsicdg71sx4v9s8vx98i2xh2n7n02wxkxivwj468151ci0";
      name = "qt3d-everywhere-src-6.5.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qt5compat-everywhere-src-6.5.0.tar.xz";
      sha256 = "0q8jq9ccb0as7qhxqgs1q84i7qxz3xx6wbqsn0qy3hiz34xgbqm9";
      name = "qt5compat-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtactiveqt-everywhere-src-6.5.0.tar.xz";
      sha256 = "0fwwz2ag4s03kicmgkpvgg3n6glx2ld21b24xqi3ib5av75smc15";
      name = "qtactiveqt-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtbase-everywhere-src-6.5.0.tar.xz";
      sha256 = "1vzmxak112llvnx9rdgss99i9bc88rzsaxn59wdyqr5y9xxsmqgx";
      name = "qtbase-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtcharts-everywhere-src-6.5.0.tar.xz";
      sha256 = "1a165qz40yc50wdzk9sz0va6nc92y280x3k6yw8y0vgmlx81vkgw";
      name = "qtcharts-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtconnectivity-everywhere-src-6.5.0.tar.xz";
      sha256 = "01lgd6bv23zgj0c788h4ii192mf8cvcm2d5jfwd3d1mrp99ncqz7";
      name = "qtconnectivity-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtdatavis3d-everywhere-src-6.5.0.tar.xz";
      sha256 = "0sw1m61md30n06whl7s1d8ylr24pxjqs4q66a617vbp72xvw32nl";
      name = "qtdatavis3d-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtdeclarative-everywhere-src-6.5.0.tar.xz";
      sha256 = "15wcb2zq4sl1aw8yc1np9bp2p0df4r9in3zks3d9255wiv6k3mpp";
      name = "qtdeclarative-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtdoc-everywhere-src-6.5.0.tar.xz";
      sha256 = "1fblc7yr2gxmwi325lv3pwfkbbdrk2i4564y4fwdahl58xncwqi6";
      name = "qtdoc-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtgrpc-everywhere-src-6.5.0.tar.xz";
      sha256 = "1wrgrr58lyg3g8dc5a3qbl7p0ym6k6g9zkly0kwz6pbbihv4p7sq";
      name = "qtgrpc-everywhere-src-6.5.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qthttpserver-everywhere-src-6.5.0.tar.xz";
      sha256 = "0mnmaz333prww2b5vxjix4zlm1pgi2snavpqbg4swprvh93pc3b7";
      name = "qthttpserver-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtimageformats-everywhere-src-6.5.0.tar.xz";
      sha256 = "0y3g0i11nfrg1h1d7jnnckky6hnfrx7z6cysq0r03rn77b6i1y7r";
      name = "qtimageformats-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtlanguageserver-everywhere-src-6.5.0.tar.xz";
      sha256 = "078siwgsb1ypiim869jdkkmp32g715kkc76fj6764id3yg9d7j4d";
      name = "qtlanguageserver-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtlocation-everywhere-src-6.5.0.tar.xz";
      sha256 = "036351d5yb35fma1wpvh6zcrbcsfg97ks6hy67vlbbsq958aggqf";
      name = "qtlocation-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtlottie-everywhere-src-6.5.0.tar.xz";
      sha256 = "0ip2nx169pvrxrpw1viivh20sq96c29z7njvk18nqsi8p7gfq9c4";
      name = "qtlottie-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtmultimedia-everywhere-src-6.5.0.tar.xz";
      sha256 = "0im1visfb2r88pcrx7sb80znl17cij9l1qwr93n1ml5x7b3x104l";
      name = "qtmultimedia-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtnetworkauth-everywhere-src-6.5.0.tar.xz";
      sha256 = "0gj14j50d50fl0rjwilss4nakvxwldbg3iz5kdnbwvhkn8m55k6v";
      name = "qtnetworkauth-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtpositioning-everywhere-src-6.5.0.tar.xz";
      sha256 = "11n86llfixrgqw7yqxr1fcspq0khmyiwiwmibacbmlnrpwg159qd";
      name = "qtpositioning-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtquick3d-everywhere-src-6.5.0.tar.xz";
      sha256 = "19bj6xzw63rwbzlj7lb0hbni37syfyiyzwjdxj6crdcqr8lh8ncv";
      name = "qtquick3d-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtquick3dphysics-everywhere-src-6.5.0.tar.xz";
      sha256 = "04f0k2z3sqpbkjn74ral0q5s2hkkzijnr5ay9f91c6lg4ciaki81";
      name = "qtquick3dphysics-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtquickeffectmaker-everywhere-src-6.5.0.tar.xz";
      sha256 = "1mwwn8psmq0lbv1ggc4g42ns93ygg6yqd555aq7qkxyhr9rcccjb";
      name = "qtquickeffectmaker-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtquicktimeline-everywhere-src-6.5.0.tar.xz";
      sha256 = "1gygaxb9p6d23q5nxmhjlmazzx4i3vkhvjsi9v6l7d32js93x2sp";
      name = "qtquicktimeline-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtremoteobjects-everywhere-src-6.5.0.tar.xz";
      sha256 = "1bn24l46ia0nvvcbzs5h3wg5nlk94m35fqrv1lcl8km8mzkvch7z";
      name = "qtremoteobjects-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtscxml-everywhere-src-6.5.0.tar.xz";
      sha256 = "0vkn2p4w21z9a6q27hf4yda85hjs4s01wdxy47b7cjngp0y888gi";
      name = "qtscxml-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtsensors-everywhere-src-6.5.0.tar.xz";
      sha256 = "19ifwxbsa0k2p7z4wa1q4g4shi668w9wprhxkcp2sz4iyki39r2y";
      name = "qtsensors-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtserialbus-everywhere-src-6.5.0.tar.xz";
      sha256 = "15s82ic6w5jw8c1xnwwmskchynvcazmfq4ai7kfrz764ca9kfj4p";
      name = "qtserialbus-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtserialport-everywhere-src-6.5.0.tar.xz";
      sha256 = "1zsd9aas8p7zgfjx2fji0mfn6fzy6822g0h52lxdyjlajzssj2cj";
      name = "qtserialport-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtshadertools-everywhere-src-6.5.0.tar.xz";
      sha256 = "0xapkzvz79wspc1a9l6yvp7m2vsfmrvapdsymkvz2w9hgw1qsqc6";
      name = "qtshadertools-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtspeech-everywhere-src-6.5.0.tar.xz";
      sha256 = "16ixx1b8r5v5m04jpjylixpl4xw1qh5g0dp4phj40vg5z8vjg08x";
      name = "qtspeech-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtsvg-everywhere-src-6.5.0.tar.xz";
      sha256 = "0kvs0sb32r4izskh17l771z9lfmmk6951q5lrf5y4ladyihpxjk4";
      name = "qtsvg-everywhere-src-6.5.0.tar.xz";
    };
  };
  qttools = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qttools-everywhere-src-6.5.0.tar.xz";
      sha256 = "1i39cdl0mmf0wxmkmq16jx1mnj8s7p7bhsa2jnz8hjd4n2b3vhs9";
      name = "qttools-everywhere-src-6.5.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qttranslations-everywhere-src-6.5.0.tar.xz";
      sha256 = "0gbs0shf9hm0xrj3n3zkfdpdymks2wa11nna7ijiixckhgyx11gw";
      name = "qttranslations-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtvirtualkeyboard-everywhere-src-6.5.0.tar.xz";
      sha256 = "19qg59yhln7hbny6nfaz9wx4cm8ng3j23y3snpsfj5q84iwdwibv";
      name = "qtvirtualkeyboard-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtwayland-everywhere-src-6.5.0.tar.xz";
      sha256 = "18sr2yijlm4yh13kq8v7l1knp6b01blflcs75hf1qpzwfyi7zifc";
      name = "qtwayland-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtwebchannel-everywhere-src-6.5.0.tar.xz";
      sha256 = "1gzi03nqgaai0jjhy61gasdydkd0xpvrnq671671ns7kdmj3smfr";
      name = "qtwebchannel-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtwebengine-everywhere-src-6.5.0.tar.xz";
      sha256 = "01vg60g25aabki4xlszfn3aq62yjbm2qdh0yy6gpwc0vlwsdl41a";
      name = "qtwebengine-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtwebsockets-everywhere-src-6.5.0.tar.xz";
      sha256 = "0233c75by9n48hvm9wc8zmsry8ba0ckykdna1h9dld5vavb7n25w";
      name = "qtwebsockets-everywhere-src-6.5.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.5.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.0/submodules/qtwebview-everywhere-src-6.5.0.tar.xz";
      sha256 = "087hs60bzpgqs08z2prfbg9544mpii0xn4xkslp24zbaq43l5aq5";
      name = "qtwebview-everywhere-src-6.5.0.tar.xz";
    };
  };
}
