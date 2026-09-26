# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qt3d-everywhere-src-6.11.2.tar.xz";
      sha256 = "0adczdz74mlmrb8w7hzjln1902isn7bgfbzpr1r18wasg6j8a4a1";
      name = "qt3d-everywhere-src-6.11.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qt5compat-everywhere-src-6.11.2.tar.xz";
      sha256 = "11s225zq0hskkq61rrfhy65aqzdny7np00c75ngnl2ci6gz21hv8";
      name = "qt5compat-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtactiveqt-everywhere-src-6.11.2.tar.xz";
      sha256 = "0g3ak3jmh4fqjl0xh3vcj7hlw7k7902b2arqxa304hmh1s0dmblx";
      name = "qtactiveqt-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtbase-everywhere-src-6.11.2.tar.xz";
      sha256 = "08ng4gns21a3za3qszzw3yp3a2pxipma1zrl870xi97mrbn00bjv";
      name = "qtbase-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtcanvaspainter-everywhere-src-6.11.2.tar.xz";
      sha256 = "0q77hc83ynvnagwxa9z0j9rwvlzmyig06kklb7v5zvyfa1ra544a";
      name = "qtcanvaspainter-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtcharts-everywhere-src-6.11.2.tar.xz";
      sha256 = "0agvnva90diqvllfvrd1smicar6nlv5pjqvwjfg509fih4xyasah";
      name = "qtcharts-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtconnectivity-everywhere-src-6.11.2.tar.xz";
      sha256 = "0dv0bqlvfdphk2a5pzq7fm222h6zvy87k18aaamq7585pmbimc45";
      name = "qtconnectivity-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtdatavis3d-everywhere-src-6.11.2.tar.xz";
      sha256 = "07b61fkdzkhv3hfa7r6vfadd72bnyk4cgqwws5ns3y6nqlcnjknj";
      name = "qtdatavis3d-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtdeclarative-everywhere-src-6.11.2.tar.xz";
      sha256 = "0c5lqr8kbrfvaxh147d92vqbcirw7wj94sxwx8ih2f3ya5q7nnr1";
      name = "qtdeclarative-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtdoc-everywhere-src-6.11.2.tar.xz";
      sha256 = "1dsfnlsk0kihz55fnmyrybya9x3s88nam9jfpb5g68vk4n9if9sn";
      name = "qtdoc-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtgraphs-everywhere-src-6.11.2.tar.xz";
      sha256 = "08cbzc0146j4d18dlqsw0qbilhcwk1hi9h8n84adsigs9a2hj8cz";
      name = "qtgraphs-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtgrpc-everywhere-src-6.11.2.tar.xz";
      sha256 = "14xdchng4sn90r2cva7wxrqlyzncpwkj11gscm4z73q5y0blcha4";
      name = "qtgrpc-everywhere-src-6.11.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qthttpserver-everywhere-src-6.11.2.tar.xz";
      sha256 = "13mxwy5h41c96ykdkxlxcdf2pqv2gswyvyzxrzsj13x55cxpdxgh";
      name = "qthttpserver-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtimageformats-everywhere-src-6.11.2.tar.xz";
      sha256 = "1y0123s8hry81059w8x46fv0i0425zv99g09cc3m0rabyc08kkff";
      name = "qtimageformats-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtlanguageserver-everywhere-src-6.11.2.tar.xz";
      sha256 = "0ppw27jsqsih48sd0iizfc2jwsxya8z0a9vjjaqhxjplxir45g1q";
      name = "qtlanguageserver-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtlocation-everywhere-src-6.11.2.tar.xz";
      sha256 = "0fn2clzz2wmc3lwzqlkwk07scvmmdhim1ihpxkv7dg8zw3nafl2d";
      name = "qtlocation-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtlottie-everywhere-src-6.11.2.tar.xz";
      sha256 = "0lj8a90frd265waypkwghabj0r9h5p6vh1dlrjksksyr2qkp2g7m";
      name = "qtlottie-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtmultimedia-everywhere-src-6.11.2.tar.xz";
      sha256 = "17yd17qm0jxfimkqs843z5m86ciif1pcs8h66vdkqybbxh15wywn";
      name = "qtmultimedia-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtnetworkauth-everywhere-src-6.11.2.tar.xz";
      sha256 = "0nx03zab9jrzkrwali45czswlniwbh0v0nx17wwj8y5bfwqc50qc";
      name = "qtnetworkauth-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtopenapi-everywhere-src-6.11.2.tar.xz";
      sha256 = "1873byinl4ikm3bncz869fjhn1z2jwj9s0bg3h9ncnn4kl0fp74b";
      name = "qtopenapi-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtpositioning-everywhere-src-6.11.2.tar.xz";
      sha256 = "16blmv0plbh0l214q6phfp7jb18201cyqk66v8555cd38fnibkyq";
      name = "qtpositioning-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtquick3d-everywhere-src-6.11.2.tar.xz";
      sha256 = "1d1pcy9ipjsipczrassn6h9jq2bx7v1457fg6wx3f9nvivqf3f1s";
      name = "qtquick3d-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtquick3dphysics-everywhere-src-6.11.2.tar.xz";
      sha256 = "0vmqvr68qq0caglackln225xj3p8srdycykw3m44iz458b7j8nhw";
      name = "qtquick3dphysics-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtquickeffectmaker-everywhere-src-6.11.2.tar.xz";
      sha256 = "1dswhg102b09x3p3iyldmwkhnkphcisl4jp2dbisacz9hirdq8vr";
      name = "qtquickeffectmaker-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtquicktimeline-everywhere-src-6.11.2.tar.xz";
      sha256 = "05qxi1gqv02af28rlzlbmxc4v939i920gqblvrfh9i50002z22i5";
      name = "qtquicktimeline-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtremoteobjects-everywhere-src-6.11.2.tar.xz";
      sha256 = "1zbwg7pzswibjjx2vgcl3r4v47xhdwk0c9bik8bv3hlyg60rc32y";
      name = "qtremoteobjects-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtscxml-everywhere-src-6.11.2.tar.xz";
      sha256 = "1zrmxhf2a58dynbxij08vxa6x7b6jllcfwvrhlhgpgzqlyxw957m";
      name = "qtscxml-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtsensors-everywhere-src-6.11.2.tar.xz";
      sha256 = "069ij142dvh4spqp9584pfqqj8265x659xb35wcf5s1jzd6y9j38";
      name = "qtsensors-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtserialbus-everywhere-src-6.11.2.tar.xz";
      sha256 = "1h9nvwhbfhb5js0458ha653n04d46m70j4gh8gn4bc7njnxcj1lg";
      name = "qtserialbus-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtserialport-everywhere-src-6.11.2.tar.xz";
      sha256 = "13md2wdypib4wjw3mai8hqfyjjs4l67232dnxjr32ks42qv76fnz";
      name = "qtserialport-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtshadertools-everywhere-src-6.11.2.tar.xz";
      sha256 = "070b41mzqf1b7xnxn2mh7ap79s2702a7bcwhd1c6axkmnyw4cl40";
      name = "qtshadertools-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtspeech-everywhere-src-6.11.2.tar.xz";
      sha256 = "166bqmcffdncyr64zw4h99c9ng19nk30ys371br4j03ikpf0a7cw";
      name = "qtspeech-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtsvg-everywhere-src-6.11.2.tar.xz";
      sha256 = "0xhq64622f6iz42xj4dn0jjgs4jwd9gbi1zyczxjck58xizk756m";
      name = "qtsvg-everywhere-src-6.11.2.tar.xz";
    };
  };
  qttasktree = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qttasktree-everywhere-src-6.11.2.tar.xz";
      sha256 = "1n1yq8hws4yq0raanfkjj2r4z671mic2dspg2p6sc5hny292jxn0";
      name = "qttasktree-everywhere-src-6.11.2.tar.xz";
    };
  };
  qttools = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qttools-everywhere-src-6.11.2.tar.xz";
      sha256 = "07h4nhk02izczi1wz6dh7gab84vzk7rkm30wwq4pwbsibkrmm9wy";
      name = "qttools-everywhere-src-6.11.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qttranslations-everywhere-src-6.11.2.tar.xz";
      sha256 = "0560cyg3j4fcsq7ikb7rraa8g5ymi9lscmmhqfmryylklz0q85h2";
      name = "qttranslations-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtvirtualkeyboard-everywhere-src-6.11.2.tar.xz";
      sha256 = "0bvwci70c4ng5zgzj621a723p22v58cmzbprbz6llkjw99rjcsjc";
      name = "qtvirtualkeyboard-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtwayland-everywhere-src-6.11.2.tar.xz";
      sha256 = "1pzr4a11dmlbpzfgcm7z95cvnm2r5pq71pg80vsi0aik75g63dwf";
      name = "qtwayland-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtwebchannel-everywhere-src-6.11.2.tar.xz";
      sha256 = "0pspql8j7yxjvvxwibavb4kw5lidh6a62rcjqbq8ga5xb2bi9czy";
      name = "qtwebchannel-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtwebengine-everywhere-src-6.11.2.tar.xz";
      sha256 = "0qy1lyykwwkp288v0y5kqnd1pmz8frzicpgfcldkv4zz02mc20b1";
      name = "qtwebengine-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtwebsockets-everywhere-src-6.11.2.tar.xz";
      sha256 = "18y9ycpmny1czkqz7c97hp7l89vxj34h56y5wf87czy3hg1jbzib";
      name = "qtwebsockets-everywhere-src-6.11.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.11.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.2/submodules/qtwebview-everywhere-src-6.11.2.tar.xz";
      sha256 = "0k0zi0pzbcvrrjfzhim55rbaar4xrdmpip9y5ppxxnl9xq4y28by";
      name = "qtwebview-everywhere-src-6.11.2.tar.xz";
    };
  };
}
