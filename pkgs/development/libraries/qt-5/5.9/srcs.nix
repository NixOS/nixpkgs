# DO NOT EDIT! This file is generated automatically by fetch-kde-qt.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qt3d-opensource-src-5.9.1.tar.xz";
      sha256 = "15j9znfnxch1n6fwz9ngi30msdzh0wlpykl53cs8g2fp2awfa7sg";
      name = "qt3d-opensource-src-5.9.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtactiveqt-opensource-src-5.9.1.tar.xz";
      sha256 = "07zq60xg7nnlny7qgj6dk1ibg3fzhbdh78gpd0s6x1n822iyislg";
      name = "qtactiveqt-opensource-src-5.9.1.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtandroidextras-opensource-src-5.9.1.tar.xz";
      sha256 = "0nq879jsa2z1l5q3n0hhiv15mzfm5c6s7zfblcc10sgim90p5mjj";
      name = "qtandroidextras-opensource-src-5.9.1.tar.xz";
    };
  };
  qtbase = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtbase-opensource-src-5.9.1.tar.xz";
      sha256 = "1ikm896jzyfyjv2qv8n3fd81sxb4y24zkygx36865ygzyvlj36mw";
      name = "qtbase-opensource-src-5.9.1.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtcanvas3d-opensource-src-5.9.1.tar.xz";
      sha256 = "10fy8wqfw2yhha6lyky5g1a72137aj8pji7mk0wjnggh629z12sb";
      name = "qtcanvas3d-opensource-src-5.9.1.tar.xz";
    };
  };
  qtcharts = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtcharts-opensource-src-5.9.1.tar.xz";
      sha256 = "180df5v7i1ki8hc3lgi6jcfdyz7f19pb73dvfkw402wa2gfcna3k";
      name = "qtcharts-opensource-src-5.9.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtconnectivity-opensource-src-5.9.1.tar.xz";
      sha256 = "1mbzmqix0388iq20a1ljd1pgdq259rm1xzp9kx8gigqpamqqnqs0";
      name = "qtconnectivity-opensource-src-5.9.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtdatavis3d-opensource-src-5.9.1.tar.xz";
      sha256 = "14d1q07winh6n1bkc616dapwfnsfkcjyg5zngdqjdj9mza8ang13";
      name = "qtdatavis3d-opensource-src-5.9.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtdeclarative-opensource-src-5.9.1.tar.xz";
      sha256 = "1zwlxrgraxhlsdkwsai3pjbz7f3a6rsnsg2mjrpay6cz3af6rznj";
      name = "qtdeclarative-opensource-src-5.9.1.tar.xz";
    };
  };
  qtdoc = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtdoc-opensource-src-5.9.1.tar.xz";
      sha256 = "1d2kk9wzm2261ap87nyf743a4662gll03gz5yh5qi7k620lk372x";
      name = "qtdoc-opensource-src-5.9.1.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtgamepad-opensource-src-5.9.1.tar.xz";
      sha256 = "055w4649zi93q1sl32ngqwgnl2vxw1idnm040s9gjgjb67gi81zi";
      name = "qtgamepad-opensource-src-5.9.1.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtgraphicaleffects-opensource-src-5.9.1.tar.xz";
      sha256 = "1zsr3a5dsmpvrb5h4m4h42wqmkvkks3d8mmyrx4k0mfr6s7c71jz";
      name = "qtgraphicaleffects-opensource-src-5.9.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtimageformats-opensource-src-5.9.1.tar.xz";
      sha256 = "0iwa3dys5rv706cpxwhmgircv783pmlyl1yrsc5i0rha643y7zkr";
      name = "qtimageformats-opensource-src-5.9.1.tar.xz";
    };
  };
  qtlocation = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtlocation-opensource-src-5.9.1.tar.xz";
      sha256 = "058mgvlaml9rkfhkpr1n3avhi12zlva131sqhbwj4lwwyqfkri2b";
      name = "qtlocation-opensource-src-5.9.1.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtmacextras-opensource-src-5.9.1.tar.xz";
      sha256 = "0096g9l2hwsiwlzfjkw7rhkdnyvb5gzjzyjjg9kqfnsagbwscv11";
      name = "qtmacextras-opensource-src-5.9.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtmultimedia-opensource-src-5.9.1.tar.xz";
      sha256 = "1r76zvbv6wwb7lgw9jwlx382iyw34i1amxaypb5bg3j1niqvx3z4";
      name = "qtmultimedia-opensource-src-5.9.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtnetworkauth-opensource-src-5.9.1.tar.xz";
      sha256 = "1fgax3p7lqcz29z2n1qxnfpkj3wxq1x9bfx61q6nss1fs74pxzra";
      name = "qtnetworkauth-opensource-src-5.9.1.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtpurchasing-opensource-src-5.9.1.tar.xz";
      sha256 = "0b1hlaq6rb7d6b6h8kqd26klcpzf9vcdjrv610kdj0drb00jg3ss";
      name = "qtpurchasing-opensource-src-5.9.1.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtquickcontrols-opensource-src-5.9.1.tar.xz";
      sha256 = "0bpc465q822phw3dcbddn70wj1fjlc2hxskkp1z9gl7r23hx03jj";
      name = "qtquickcontrols-opensource-src-5.9.1.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtquickcontrols2-opensource-src-5.9.1.tar.xz";
      sha256 = "1zq86kqz85wm3n84jcxkxw5x1mrhkqzldkigf8xm3l8j24rf0fr0";
      name = "qtquickcontrols2-opensource-src-5.9.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtremoteobjects-opensource-src-5.9.1.tar.xz";
      sha256 = "10kwq0fgmi6zsqhb6s1nkcydpyl8d8flzdpgmyj50c4h2xhg2km0";
      name = "qtremoteobjects-opensource-src-5.9.1.tar.xz";
    };
  };
  qtscript = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtscript-opensource-src-5.9.1.tar.xz";
      sha256 = "13qq2mjfhqdcvkmzrgxg1gr5kww1ygbwb7r71xxl6rjzbn30hshp";
      name = "qtscript-opensource-src-5.9.1.tar.xz";
    };
  };
  qtscxml = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtscxml-opensource-src-5.9.1.tar.xz";
      sha256 = "1m3b6wg5hqasdfc5igpj9bq3czql5kkvvn3rx1ig508kdlh5i5s0";
      name = "qtscxml-opensource-src-5.9.1.tar.xz";
    };
  };
  qtsensors = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtsensors-opensource-src-5.9.1.tar.xz";
      sha256 = "1772x7r6y9xv2sv0w2dfz2yhagsq5bpa9kdpzg0qikccmabr7was";
      name = "qtsensors-opensource-src-5.9.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtserialbus-opensource-src-5.9.1.tar.xz";
      sha256 = "1hzk377c3zl4dm5hxwvpxg2w096m160448y9df6v6l8xpzpzxafa";
      name = "qtserialbus-opensource-src-5.9.1.tar.xz";
    };
  };
  qtserialport = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtserialport-opensource-src-5.9.1.tar.xz";
      sha256 = "0sbsc7n701kxl16r247a907zg2afmbx1xlml5jkc6a9956zqbzp1";
      name = "qtserialport-opensource-src-5.9.1.tar.xz";
    };
  };
  qtspeech = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtspeech-opensource-src-5.9.1.tar.xz";
      sha256 = "00daxkf8iwf6n9rhkkv3isv5qa8wijwzb0zy1f6zlm3vcc8fz75c";
      name = "qtspeech-opensource-src-5.9.1.tar.xz";
    };
  };
  qtsvg = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtsvg-opensource-src-5.9.1.tar.xz";
      sha256 = "1rg2q4snh2g4n93zmk995swwkl0ab1jr9ka9xpj56ddifkw99wlr";
      name = "qtsvg-opensource-src-5.9.1.tar.xz";
    };
  };
  qttools = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qttools-opensource-src-5.9.1.tar.xz";
      sha256 = "1s50kh3sg5wc5gqhwwznnibh7jcnfginnmkv66w62mm74k7mdsy4";
      name = "qttools-opensource-src-5.9.1.tar.xz";
    };
  };
  qttranslations = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qttranslations-opensource-src-5.9.1.tar.xz";
      sha256 = "0sdjiqli15fmkbqvhhgjfavff906sg56jx5xf8bg6xzd2j5544ja";
      name = "qttranslations-opensource-src-5.9.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtvirtualkeyboard-opensource-src-5.9.1.tar.xz";
      sha256 = "0k79sqa8bg6gkbsk16320gnila1iiwpnl3vx03rysm5bqdnnlx3b";
      name = "qtvirtualkeyboard-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwayland = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwayland-opensource-src-5.9.1.tar.xz";
      sha256 = "1yizvbmh26mx1ffq0qaci02g2wihy68ld0y7r3z8nx3v5acb236g";
      name = "qtwayland-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebchannel-opensource-src-5.9.1.tar.xz";
      sha256 = "003h09mla82f2znb8jjigx13ivc68ikgv7w04594yy7qdmd5yhl0";
      name = "qtwebchannel-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebengine-opensource-src-5.9.1.tar.xz";
      sha256 = "00b4d18m54pbxa1hm6ijh2mrd4wmrs7lkplys8b4liw8j7mpx8zn";
      name = "qtwebengine-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebkit = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebkit-opensource-src-5.9.1.tar.xz";
      sha256 = "1ksjn1vjbfhdm4y4rg08ag4krk87ahp7qcdcpwll42l0rnz61998";
      name = "qtwebkit-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebkit-examples = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebkit-examples-opensource-src-5.9.1.tar.xz";
      sha256 = "1l2l7ycgqql6rf4gx6sjhsqjapdhvy6vxaxssax3l938nkk4vkp4";
      name = "qtwebkit-examples-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebsockets-opensource-src-5.9.1.tar.xz";
      sha256 = "0r1lya2jj3wfci82zfn0vk6vr8sk9k7xiphnkb0panhb8di769q1";
      name = "qtwebsockets-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwebview = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwebview-opensource-src-5.9.1.tar.xz";
      sha256 = "0qmxrh4y3i9n8x6yhrlnahcn75cc2xwlc8mi4g8n2d83c3x7pxyn";
      name = "qtwebview-opensource-src-5.9.1.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtwinextras-opensource-src-5.9.1.tar.xz";
      sha256 = "1x7f944f3g2ml3mm594qv6jlvl5dzzsxq86yinp7av0lhnyrxk0s";
      name = "qtwinextras-opensource-src-5.9.1.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtx11extras-opensource-src-5.9.1.tar.xz";
      sha256 = "00fn3bps48gjyw0pdqvvl9scknxdpmacby6hvdrdccc3jll0wgd6";
      name = "qtx11extras-opensource-src-5.9.1.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.9/5.9.1/submodules/qtxmlpatterns-opensource-src-5.9.1.tar.xz";
      sha256 = "094wwap2fsl23cys6rxh2ciw0gxbbiqbshnn4qs1n6xdjrj6i15m";
      name = "qtxmlpatterns-opensource-src-5.9.1.tar.xz";
    };
  };
}
