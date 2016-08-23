# DO NOT EDIT! This file is generated automatically by manifest.sh
{ fetchurl, mirror }:

{
  qtwebkit = {
    version = "5.6.1";
    src = fetchurl {
      url = "${mirror}/community_releases/5.6/5.6.1/qtwebkit-opensource-src-5.6.1.tar.xz";
      sha256 = "1akjqvjavl0vn8a8hnmvqc26mf4ljvwjdm07x6dmmdnjzajvzkzm";
      name = "qtwebkit-opensource-src-5.6.1.tar.xz";
    };
  };
  qt3d = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qt3d-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1nxpcjsarcp40m4y18kyy9a5md56wnafll03j8c6q19rba9bcwbf";
      name = "qt3d-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtactiveqt-opensource-src-5.6.1-1.tar.xz";
      sha256 = "00bj9c0x3ax34gpibaap3wpchkv4wapsydiz01fb0xzs1fy94nbf";
      name = "qtactiveqt-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtandroidextras-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0xhm4053y9hqnz5y3y4rwycniq0mb1al1rds3jx636211y039xhk";
      name = "qtandroidextras-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtbase = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtbase-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0fbwprlhqmdyhh2wb9122fcpq7pbil530iak482b9sy5gqs7i5ij";
      name = "qtbase-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtcanvas3d-opensource-src-5.6.1-1.tar.xz";
      sha256 = "13127xws6xfkkk1x617bgdzl96l66nd0v82dibdnxnpfa702rl44";
      name = "qtcanvas3d-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtconnectivity-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0sr6sxp0q45pacs25knr28139xdrphcjgrwlksdhdpsryfw19mzi";
      name = "qtconnectivity-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtdeclarative-opensource-src-5.6.1-1.tar.xz";
      sha256 = "094gx5mzqzcga97y7ihf052b6i5iv512lh7m0702m5q94nsn1pqw";
      name = "qtdeclarative-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtdeclarative-render2d = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtdeclarative-render2d-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0kqmb3792rg9fx12m64x87ahcrh0g9krg77mv0ssx3g4gvsgcibc";
      name = "qtdeclarative-render2d-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtdoc = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtdoc-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1yf3g3h72ndrp88h8g21mzgqdz2ixwkvpav03i3jnrgy2pf7nssp";
      name = "qtdoc-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtenginio = {
    version = "1.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtenginio-opensource-src-1.6.1.tar.xz";
      sha256 = "17hsrhzy9zdvpbzja45aac6jr7jzzjl206vma96b9w73rbgxa50f";
      name = "qtenginio-opensource-src-1.6.1.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtgraphicaleffects-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0560800fa9sd6dw1vk0ia9vq8ywdrwch2cpsi1vmh4iyxgwfr71b";
      name = "qtgraphicaleffects-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtimageformats-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1p98acvsm3azka2by1ph4gdb31qbnndrr5k5wns4xk2d760y8ifc";
      name = "qtimageformats-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtlocation = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtlocation-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0my4pbcxa58yzvdh65l5qx99ln03chjr5c3ml5v37wfk7nx23k69";
      name = "qtlocation-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtmacextras-opensource-src-5.6.1-1.tar.xz";
      sha256 = "07j26d5g7av4c6alggg5hssqpvdh555zmn1cpr8xrhx1hpbdnaas";
      name = "qtmacextras-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtmultimedia-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0paffx0614ivjbf87lr9klpbqik6r1pzbc14l41np6d9jv3dqa2f";
      name = "qtmultimedia-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtquickcontrols2-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0wfa2xcqsvx3zihd5nb9f9qhq0xn14c03sw1qdymzfsryqwmk4ac";
      name = "qtquickcontrols2-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtquickcontrols-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0cjzf844r7wi32ssc9vbw1a2m9hnr8c0i1p7yyljy962ifplf401";
      name = "qtquickcontrols-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtscript = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtscript-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1gini9483flqa9q4a4bl81bh7g5s408bycqykqhgbklmfd29y5lx";
      name = "qtscript-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtsensors = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtsensors-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0kcrvf6vzn6g2v2m70f9r3raalzmfp48rwjlqhss3w84jfz3y04r";
      name = "qtsensors-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtserialbus-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0li4g70s5vfb517ag0d6405ymsknvvny1c8x66w7qs8a8mnk1jq5";
      name = "qtserialbus-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtserialport = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtserialport-opensource-src-5.6.1-1.tar.xz";
      sha256 = "135cbgghxk0c6dblmyyrw6znfb9m8sac9hhyc2dm6vq7vzy8id52";
      name = "qtserialport-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtsvg = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtsvg-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1w0jvhgaiddafcms2nv8wl1klg07lncmjwm1zhdw3l6rxi9071sw";
      name = "qtsvg-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qttools = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qttools-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0haic027a2d7p7k8xz83fbvci4a4dln34360rlwgy7hlyy5m4nip";
      name = "qttools-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qttranslations = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qttranslations-opensource-src-5.6.1-1.tar.xz";
      sha256 = "03sdzci4pgq6lmxwn25v8x0z5x8g7zgpq2as56dqgj7vp6cvhn8m";
      name = "qttranslations-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwayland = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwayland-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1fnvgpi49ilds3ah9iizxj9qhhb5rnwqd9h03bhkwf0ydywv52c4";
      name = "qtwayland-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwebchannel-opensource-src-5.6.1-1.tar.xz";
      sha256 = "10kys3ppjkj60fs1s335fdcpdsbxsjn6ibvm6zph9gqbncabd2l7";
      name = "qtwebchannel-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwebengine-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0k708a34zwkj6hwx3vv5kdvnv3lfgb0iad44zaim5gdpgcir03n8";
      name = "qtwebengine-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwebsockets-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1fz0x8570zxc00a22skd848svma3p2g3xyxj14jq10559jihqqil";
      name = "qtwebsockets-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwebview = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwebview-opensource-src-5.6.1-1.tar.xz";
      sha256 = "19954snfw073flxn0qk5ayxyzk5x6hwhpg4kn4nrl1zygsw3y49l";
      name = "qtwebview-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtwinextras-opensource-src-5.6.1-1.tar.xz";
      sha256 = "03zkwqrix2nfqkwfn8lsrpgahzx1hv6p1qbvhkqymzakkzjjncgg";
      name = "qtwinextras-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtx11extras-opensource-src-5.6.1-1.tar.xz";
      sha256 = "0yj5yg2dqkrwbgbicmk2rpqsagmi8dsffkrprpsj0fmkx4awhv5y";
      name = "qtx11extras-opensource-src-5.6.1-1.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.6.1-1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.1-1/submodules/qtxmlpatterns-opensource-src-5.6.1-1.tar.xz";
      sha256 = "1966rrk7f6c55k57j33rffdjs77kk4mawrnnl8yv1ckcirxc3np1";
      name = "qtxmlpatterns-opensource-src-5.6.1-1.tar.xz";
    };
  };
}
