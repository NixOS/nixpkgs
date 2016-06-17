# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
  qtxmlpatterns = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtxmlpatterns-opensource-src-5.6.1.tar.xz";
      sha256 = "0q412jv3xbg7v05b8pbahifwx17gzlp96s90akh6zwhpm8i6xx34";
      name = "qtxmlpatterns-opensource-src-5.6.1.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtx11extras-opensource-src-5.6.1.tar.xz";
      sha256 = "0l736qiz8adrnh267xz63hv4sph6nhy90h836qfnnmv3p78ipsz8";
      name = "qtx11extras-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwinextras-opensource-src-5.6.1.tar.xz";
      sha256 = "1db3lcrj8af0z8lnh99lfbwz1cq9il7rr27rk9l38dff65qkssm8";
      name = "qtwinextras-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwebview = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwebview-opensource-src-5.6.1.tar.xz";
      sha256 = "0q869wl61vidds551w3z49ysx88xqyn6igbz07zxac7d0gwgwpda";
      name = "qtwebview-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwebsockets-opensource-src-5.6.1.tar.xz";
      sha256 = "0fkj52i4yi6gmq4jfjgdij08cspxspac6mbpf0fknnllimmkl7jm";
      name = "qtwebsockets-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwebengine-opensource-src-5.6.1.tar.xz";
      sha256 = "0yv0cflgywsyfn84vv2vc9rwpm8j7hin61rxqjqh498nnl2arw5x";
      name = "qtwebengine-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwebchannel-opensource-src-5.6.1.tar.xz";
      sha256 = "01q80917a1048hdhaii4v50dqs84h16lc9w3v99r9xvspk8vab7q";
      name = "qtwebchannel-opensource-src-5.6.1.tar.xz";
    };
  };
  qtwayland = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtwayland-opensource-src-5.6.1.tar.xz";
      sha256 = "1jgghjfrg0wwyfzfwgwhagwxz9k936ylv3w2l9bwlpql8rgm8d11";
      name = "qtwayland-opensource-src-5.6.1.tar.xz";
    };
  };
  qttranslations = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qttranslations-opensource-src-5.6.1.tar.xz";
      sha256 = "008wyk00mqz116pigm0qq78rvg28v6ykjnjxppkjnk0yd6i2vmb9";
      name = "qttranslations-opensource-src-5.6.1.tar.xz";
    };
  };
  qttools = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qttools-opensource-src-5.6.1.tar.xz";
      sha256 = "0wbzq60d7lkvlb7b5lqcw87qgy6kyjz1npjavz8f4grdxsaqi8vp";
      name = "qttools-opensource-src-5.6.1.tar.xz";
    };
  };
  qtsvg = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtsvg-opensource-src-5.6.1.tar.xz";
      sha256 = "08ca5g46g75acy27jfnvnalmcias5hxmjp7491v3y4k9y7a4ybpi";
      name = "qtsvg-opensource-src-5.6.1.tar.xz";
    };
  };
  qtserialport = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtserialport-opensource-src-5.6.1.tar.xz";
      sha256 = "1hp63cgqhps6y1k041lzhcb2b0rcpcmszabnn293q5ilbvla4x0b";
      name = "qtserialport-opensource-src-5.6.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtserialbus-opensource-src-5.6.1.tar.xz";
      sha256 = "1h683dkvnf2rdgxgisybnp8miqgn2gpi597rgx5zc7qk2k8kyidz";
      name = "qtserialbus-opensource-src-5.6.1.tar.xz";
    };
  };
  qtsensors = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtsensors-opensource-src-5.6.1.tar.xz";
      sha256 = "0bll7ll6s5g8w89knyrc0famjwqyfzwpn512m1f96bf6xwacs967";
      name = "qtsensors-opensource-src-5.6.1.tar.xz";
    };
  };
  qtscript = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtscript-opensource-src-5.6.1.tar.xz";
      sha256 = "17zp5dlfplrnzlw233lzapj55drjqchvayajd02qsggzms3yzchw";
      name = "qtscript-opensource-src-5.6.1.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtquickcontrols2-opensource-src-5.6.1.tar.xz";
      sha256 = "13zbiv63b76ifpjalx5616nixfwjk48q977bzb1xxj363b7xv85v";
      name = "qtquickcontrols2-opensource-src-5.6.1.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtquickcontrols-opensource-src-5.6.1.tar.xz";
      sha256 = "14d68ryn7r7rs7klpldnavcsccvyyg0xhwqkvjlm5wwplv2acah1";
      name = "qtquickcontrols-opensource-src-5.6.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtmultimedia-opensource-src-5.6.1.tar.xz";
      sha256 = "058523c2qra3d8fq46ygcndnkrbwlh316zy28s2cr5pjr5gmnjyj";
      name = "qtmultimedia-opensource-src-5.6.1.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtmacextras-opensource-src-5.6.1.tar.xz";
      sha256 = "147yhv7fb0yaakrffqiw6xz8ycqdc7qsnxvnpr6j8rarw5xmdc73";
      name = "qtmacextras-opensource-src-5.6.1.tar.xz";
    };
  };
  qtlocation = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtlocation-opensource-src-5.6.1.tar.xz";
      sha256 = "0qahs7a2n3l4h0bl8bnwci9mzy1vra3zncnzr40csic9ys67ddfk";
      name = "qtlocation-opensource-src-5.6.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtimageformats-opensource-src-5.6.1.tar.xz";
      sha256 = "020v1148433zx4g87z2r8fgff32n0laajxqqsja1l3yzz7jbrwvl";
      name = "qtimageformats-opensource-src-5.6.1.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtgraphicaleffects-opensource-src-5.6.1.tar.xz";
      sha256 = "1n0i2drfr7fvydgg810dcij8mxnygdpvqcqv7l1a9a1kv9ap3sap";
      name = "qtgraphicaleffects-opensource-src-5.6.1.tar.xz";
    };
  };
  qtenginio = {
    version = "1.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtenginio-opensource-src-1.6.1.tar.xz";
      sha256 = "1iq4lnz3s6mfdgml61b9lsjisky55bbvsdj72kh003j94mzrc3l5";
      name = "qtenginio-opensource-src-1.6.1.tar.xz";
    };
  };
  qtdoc = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtdoc-opensource-src-5.6.1.tar.xz";
      sha256 = "0yg7903vk4w3h6jjyanssfcig0s2s660q11sj14nw6gcjs7kfa5z";
      name = "qtdoc-opensource-src-5.6.1.tar.xz";
    };
  };
  qtdeclarative-render2d = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtdeclarative-render2d-opensource-src-5.6.1.tar.xz";
      sha256 = "1m08x8x355545r9wgrjl5p26zjhp5q1yh3h25dww8pk25v6cn8dg";
      name = "qtdeclarative-render2d-opensource-src-5.6.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtdeclarative-opensource-src-5.6.1.tar.xz";
      sha256 = "1d2217kxk85kpi7ls08b41hqzy26hvch8m4cgzq6km5sqi5zvz0j";
      name = "qtdeclarative-opensource-src-5.6.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtconnectivity-opensource-src-5.6.1.tar.xz";
      sha256 = "06fr9321f52kf0nda9zjjfzp5694hbnx0y0v315iw28mnpvandas";
      name = "qtconnectivity-opensource-src-5.6.1.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtcanvas3d-opensource-src-5.6.1.tar.xz";
      sha256 = "0q17hwmj893pk0lhxmibxmgk6h1gy4ksqfi62rkfzcf81bg2q7hr";
      name = "qtcanvas3d-opensource-src-5.6.1.tar.xz";
    };
  };
  qtbase = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtbase-opensource-src-5.6.1.tar.xz";
      sha256 = "0r3jrqymnnxrig4f11xvs33c26f0kzfakbp3kcbdpv795gpc276h";
      name = "qtbase-opensource-src-5.6.1.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtandroidextras-opensource-src-5.6.1.tar.xz";
      sha256 = "0prkpb57j0s8k36sba47k2bhs3ajf01rdwc7qf5gkvhs991rwckc";
      name = "qtandroidextras-opensource-src-5.6.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qtactiveqt-opensource-src-5.6.1.tar.xz";
      sha256 = "0a2p0w03d04hqg71hlihj9mr6aasvb0h8jfa5rnq8b5rkm8haf4f";
      name = "qtactiveqt-opensource-src-5.6.1.tar.xz";
    };
  };
  qt3d = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1/submodules/qt3d-opensource-src-5.6.1.tar.xz";
      sha256 = "03d81sls30a20yna6940np15112ciwy5024f8n5imaxicm8h34xd";
      name = "qt3d-opensource-src-5.6.1.tar.xz";
    };
  };
}
