# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qt3d-everywhere-src-6.8.3.tar.xz";
      sha256 = "0qwmwyqxa5c3kmnlcvs0wpbd1xyak3l6xwapks6iajzxgzkinph9";
      name = "qt3d-everywhere-src-6.8.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qt5compat-everywhere-src-6.8.3.tar.xz";
      sha256 = "0bmq2vd1cx4h6gpv86740pskyx8923764a27ikfj7d1lzx5wifal";
      name = "qt5compat-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtactiveqt-everywhere-src-6.8.3.tar.xz";
      sha256 = "13lim7mx09wrzcs1p00npwpi88ghr8vh08zc4pwy67anhjg19yh7";
      name = "qtactiveqt-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtbase-everywhere-src-6.8.3.tar.xz";
      sha256 = "100bkvs320s9gim4j7l6wkrl1abz1mwbmwwrscir1fq1as81n02n";
      name = "qtbase-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtcharts-everywhere-src-6.8.3.tar.xz";
      sha256 = "05097qxnjq8q3f3npai7yg7c4wqwhfb2c5v2pp4q2x5v91d5zail";
      name = "qtcharts-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtconnectivity-everywhere-src-6.8.3.tar.xz";
      sha256 = "0fcv7ic6lc5lxqqfnynmmqf0ccz84y012vx1fkwpgkh86cw7cwa7";
      name = "qtconnectivity-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtdatavis3d-everywhere-src-6.8.3.tar.xz";
      sha256 = "06pyhn2rh20vhb3m11rbpisiylg8y0kxwq1p6hr976vimpabc8w3";
      name = "qtdatavis3d-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtdeclarative-everywhere-src-6.8.3.tar.xz";
      sha256 = "1bxikmx0cxbsy0nwamr1lfrp44rckdp951yswyn4z2sqynwa40qz";
      name = "qtdeclarative-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtdoc-everywhere-src-6.8.3.tar.xz";
      sha256 = "0ngbvm7l3a7q9lmnwwr7ic5a50gmz733ws78x745wclpkr472lzm";
      name = "qtdoc-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtgraphs-everywhere-src-6.8.3.tar.xz";
      sha256 = "0x2wjv2nvwxdycjsrc89b2myh8d7ncc8gqap4llpi3yc24ib42x4";
      name = "qtgraphs-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtgrpc-everywhere-src-6.8.3.tar.xz";
      sha256 = "16w4n3jwkqmp98109dd80f8rrr1l2m7n3vhrfgr9sny4s64s8bq5";
      name = "qtgrpc-everywhere-src-6.8.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qthttpserver-everywhere-src-6.8.3.tar.xz";
      sha256 = "0razqcy5r5ikw4d09bg7nx4ad6c938r3jwa78b7z38vrv66yjavr";
      name = "qthttpserver-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtimageformats-everywhere-src-6.8.3.tar.xz";
      sha256 = "1j7i7vipk5a1k6lglcrs5a9hy52czk2c61ya59kh2j2yhjczp6q4";
      name = "qtimageformats-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtlanguageserver-everywhere-src-6.8.3.tar.xz";
      sha256 = "0sdlz1pqcs6lwxbbws3kh593sgmw8dn8drw4lwca9csm7h3j1lz4";
      name = "qtlanguageserver-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtlocation-everywhere-src-6.8.3.tar.xz";
      sha256 = "0hzx16y96hhjf0d0l0cnjijazqhaqz2xhk00zazjdgdnlmdfj18x";
      name = "qtlocation-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtlottie-everywhere-src-6.8.3.tar.xz";
      sha256 = "091x4svjprpix6gayn9j8f4zwl8ml4l2hc8jyp29a4ks95affcnp";
      name = "qtlottie-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtmultimedia-everywhere-src-6.8.3.tar.xz";
      sha256 = "00bbbzqlfb01qw1cggrwxsf832sfbryc9hsck0xjl5w3sw3j7s1j";
      name = "qtmultimedia-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtnetworkauth-everywhere-src-6.8.3.tar.xz";
      sha256 = "0jabxww0hgrlr8dk21az2kqpbf1p73fdvn4225gxg7as21y8pvi7";
      name = "qtnetworkauth-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtpositioning-everywhere-src-6.8.3.tar.xz";
      sha256 = "1lz9cgdd7jip5yyiwxws2maxydkf2bm8wyd2kjmmlyd7f5z9mdka";
      name = "qtpositioning-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtquick3d-everywhere-src-6.8.3.tar.xz";
      sha256 = "1psj6vym7plw2ys5z7y23ycnqhc9s2pcns2z7b2rn6sj1rq3qj1h";
      name = "qtquick3d-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtquick3dphysics-everywhere-src-6.8.3.tar.xz";
      sha256 = "1b3z56gab6aqlbjzhnygvrinw4g7l4ipsi0lx6fbspbp60sj6qp8";
      name = "qtquick3dphysics-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtquickeffectmaker-everywhere-src-6.8.3.tar.xz";
      sha256 = "01xs9nn0qfc502gvyydajzfjilv6cb5gl8djk85iwzfyl2783x6g";
      name = "qtquickeffectmaker-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtquicktimeline-everywhere-src-6.8.3.tar.xz";
      sha256 = "1pagd2dpajhy13fzv97ra8w2xp32gbfnbzrx236x6adr9zx5gfmj";
      name = "qtquicktimeline-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtremoteobjects-everywhere-src-6.8.3.tar.xz";
      sha256 = "1bxf8hbh7rvcq0c4wby8ya59xd4ywpf7r5ql60gr20ifgjkd2h2s";
      name = "qtremoteobjects-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtscxml-everywhere-src-6.8.3.tar.xz";
      sha256 = "0p1ggz79f7gifni728pgkf95kh5g3jxy9hf4vy1bg7r9nxm9gb6v";
      name = "qtscxml-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtsensors-everywhere-src-6.8.3.tar.xz";
      sha256 = "1bhya4kcr1xrvnkd3s4yddnpshlqy6h3ksk0abrhk9lz3x8afwdq";
      name = "qtsensors-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtserialbus-everywhere-src-6.8.3.tar.xz";
      sha256 = "17kygcfahn3js9gp3kbmyyz594jav3z7qwf5y8m7sxbjf7mhwj23";
      name = "qtserialbus-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtserialport-everywhere-src-6.8.3.tar.xz";
      sha256 = "19azvyf728402arj3c1la9l3wkzwr2ndr3zsfb8b7jn75lws0r61";
      name = "qtserialport-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtshadertools-everywhere-src-6.8.3.tar.xz";
      sha256 = "0iyggqmk56zpn92ij7dmri4lgvff6r393l5myvc89fny8azqiv7n";
      name = "qtshadertools-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtspeech-everywhere-src-6.8.3.tar.xz";
      sha256 = "0jsh830fq7i65nriwqha8vq94arc8ldyx1il7p05vqckz4xkxpdh";
      name = "qtspeech-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtsvg-everywhere-src-6.8.3.tar.xz";
      sha256 = "0f7lxs6hw6apb059if9zy8f3b1138d9s5fh4nm72c3zhc1j53srm";
      name = "qtsvg-everywhere-src-6.8.3.tar.xz";
    };
  };
  qttools = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qttools-everywhere-src-6.8.3.tar.xz";
      sha256 = "0flbih7k8zd6pnslzp2c0z0m2lpkcdbx4hzq7lrz354b4hcy5902";
      name = "qttools-everywhere-src-6.8.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qttranslations-everywhere-src-6.8.3.tar.xz";
      sha256 = "0cd55wai7qxy95gm6i9fkd8vbr9wcxj7qqdk41m33znqqdwivin3";
      name = "qttranslations-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtvirtualkeyboard-everywhere-src-6.8.3.tar.xz";
      sha256 = "07dv2did6rajc4l5b80733mm0mh2xpw8745p83n8i3gdc490c4c1";
      name = "qtvirtualkeyboard-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtwayland-everywhere-src-6.8.3.tar.xz";
      sha256 = "1c4lk5qdqjrknrjniisfvbhs1ff8rxyw301ib8b904fjhxc3izi0";
      name = "qtwayland-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtwebchannel-everywhere-src-6.8.3.tar.xz";
      sha256 = "0qhjhcacgg74jya0vclmsy8j5mimiscjwlj7fnrcfzqbcnr4cw4n";
      name = "qtwebchannel-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtwebengine-everywhere-src-6.8.3.tar.xz";
      sha256 = "0dvkz0mjxnmpi52mdzqwiilglzrpjwjxd67rnr8ham1s5fx1jknz";
      name = "qtwebengine-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtwebsockets-everywhere-src-6.8.3.tar.xz";
      sha256 = "04cvf019j21vgcja9j1ns0wr5mjfayk7lwk222ij4vidn70i0qzw";
      name = "qtwebsockets-everywhere-src-6.8.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.8.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.3/submodules/qtwebview-everywhere-src-6.8.3.tar.xz";
      sha256 = "1lky91xnjx8izyiihix16mqp53zsld855lfvni5jb2jc0drf8iic";
      name = "qtwebview-everywhere-src-6.8.3.tar.xz";
    };
  };
}
