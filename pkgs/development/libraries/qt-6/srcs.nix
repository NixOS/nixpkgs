# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qt3d-everywhere-src-6.6.1.tar.xz";
      sha256 = "0a9j8k1561hgsigpf3k5h9p788pab7lb38q7yrl1r9ql9zbsx17k";
      name = "qt3d-everywhere-src-6.6.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qt5compat-everywhere-src-6.6.1.tar.xz";
      sha256 = "1wn13filgwz9lh0jj7w8i9ma53vw4mbxj2c1421j65x4xnv1a78f";
      name = "qt5compat-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtactiveqt-everywhere-src-6.6.1.tar.xz";
      sha256 = "1v6g0hg5qfbvbvr9k5sn02l556c5mnnnak0bm1yrgqyw85qg2l4r";
      name = "qtactiveqt-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtbase-everywhere-src-6.6.1.tar.xz";
      sha256 = "1xq2kpawq1f9qa3dzjcl1bl6h039807pykcm0znl1zmjfx35n325";
      name = "qtbase-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtcharts-everywhere-src-6.6.1.tar.xz";
      sha256 = "1dii5amdzpm65mq1yz7w1aql95yi0dshm06s62yf3dr68nlwlmhi";
      name = "qtcharts-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtconnectivity-everywhere-src-6.6.1.tar.xz";
      sha256 = "0i86iqjx8z6qymbmilrmr2d67piinwlr2pkcfj1zjks69538sijv";
      name = "qtconnectivity-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtdatavis3d-everywhere-src-6.6.1.tar.xz";
      sha256 = "18hvlz8l55jzhpp1ph1slj472l65pk3qdhmhib6gybi2iv6kpp5r";
      name = "qtdatavis3d-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtdeclarative-everywhere-src-6.6.1.tar.xz";
      sha256 = "0p4r12v9ih1l9cnbw0am878kjfpr3f6whkamx564cn36iqrxgzvy";
      name = "qtdeclarative-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtdoc-everywhere-src-6.6.1.tar.xz";
      sha256 = "0ndh1if6886m9z9kc2aa02q135ar0rmy4vgln4rkr3lyx4jaajwl";
      name = "qtdoc-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtgraphs-everywhere-src-6.6.1.tar.xz";
      sha256 = "0xv4alb93rdqzbhhvvhg2miwjyax81pf9n4p5irlcg2xrw1qv5n8";
      name = "qtgraphs-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtgrpc-everywhere-src-6.6.1.tar.xz";
      sha256 = "1k7hv2f1s628rfls2klxvd0b2rb304pysbcvvqfrwkkv4ys4akhw";
      name = "qtgrpc-everywhere-src-6.6.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qthttpserver-everywhere-src-6.6.1.tar.xz";
      sha256 = "0k0jhgxfqq0l3jhrf5qyd38achvvv8x4zvx4jw0jl00m5zsv7zhv";
      name = "qthttpserver-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtimageformats-everywhere-src-6.6.1.tar.xz";
      sha256 = "13qqj8251l9885mcaafg6plxcza4vd7sdkv2wrdkfbh7a24x0kmc";
      name = "qtimageformats-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtlanguageserver-everywhere-src-6.6.1.tar.xz";
      sha256 = "0vrywwjg5d2fx2kpjxmi6cm8vffpf0zg63zi3n9dz2d90db1yxmh";
      name = "qtlanguageserver-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtlocation-everywhere-src-6.6.1.tar.xz";
      sha256 = "0acwkwcr5dixhwhd102kmh5yq4y3wk1kddfdb8ychy3jwdi2pgld";
      name = "qtlocation-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtlottie-everywhere-src-6.6.1.tar.xz";
      sha256 = "1j4zl2yz9pybh21wscfr56pahfrn4fnkvxdhkz03d2gpcj9hbjs9";
      name = "qtlottie-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtmultimedia-everywhere-src-6.6.1.tar.xz";
      sha256 = "0jnvc09msjqr2zbyjj7fgilf7zg3sdldbppnj8b9c52pdwly5r3y";
      name = "qtmultimedia-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtnetworkauth-everywhere-src-6.6.1.tar.xz";
      sha256 = "0j8dq10wq6y02cz4lkqw60nqi600qr9ssb36n74mywr2bfa12gk9";
      name = "qtnetworkauth-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtpositioning-everywhere-src-6.6.1.tar.xz";
      sha256 = "1f0n721k4w6jiva8hhgpd29im2h5vsd2ypfbk1j53f0j7czwgnix";
      name = "qtpositioning-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtquick3d-everywhere-src-6.6.1.tar.xz";
      sha256 = "08l4rsw7v0xvdmpm80wpxy74798j70r37853hdgipmi34bp0058m";
      name = "qtquick3d-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtquick3dphysics-everywhere-src-6.6.1.tar.xz";
      sha256 = "0np14lkvc3y0y896m9f754pfi83k5jnmg5i76kgfc7bvipsvbiic";
      name = "qtquick3dphysics-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtquickeffectmaker-everywhere-src-6.6.1.tar.xz";
      sha256 = "0lr6vms6vrmaki4ssmclsxi8xp3qnysgygqgn83vg727qx9hj65c";
      name = "qtquickeffectmaker-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtquicktimeline-everywhere-src-6.6.1.tar.xz";
      sha256 = "0s71zycq3l9px8hig8g229ln91h9czhxvvbj6zmmnhkx694gaq1q";
      name = "qtquicktimeline-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtremoteobjects-everywhere-src-6.6.1.tar.xz";
      sha256 = "16cmzc3cssfvqhvhc7lphbha00mdb1qykk877shgrh4bzyc5i7mq";
      name = "qtremoteobjects-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtscxml-everywhere-src-6.6.1.tar.xz";
      sha256 = "15q8vlhd9yz33bdhm7md426a33px4dg8sa14ckirk4rryixcajw7";
      name = "qtscxml-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtsensors-everywhere-src-6.6.1.tar.xz";
      sha256 = "1lwr6xw4flzcqvb017wl9g8p5yamf0z4zqx2wp4rmhrgbj0yw4xx";
      name = "qtsensors-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtserialbus-everywhere-src-6.6.1.tar.xz";
      sha256 = "1b7pkvs131vqls4bahqkwgnbrnb8pcrnii47ww2c589h1dimw52w";
      name = "qtserialbus-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtserialport-everywhere-src-6.6.1.tar.xz";
      sha256 = "1n5fsb3ayn1xnf1s5l7f6j1nm2pcdjywy382qr451b5wbhyj7z4n";
      name = "qtserialport-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtshadertools-everywhere-src-6.6.1.tar.xz";
      sha256 = "1fvkbrw6gy8v2ql6qw1ra08wl6z64w34b9d886794m29ypj8ycq8";
      name = "qtshadertools-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtspeech-everywhere-src-6.6.1.tar.xz";
      sha256 = "16aqjaf8c64l6qg0kz5hla6q2r7k9lryad7jy8jwyi2ir5921352";
      name = "qtspeech-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtsvg-everywhere-src-6.6.1.tar.xz";
      sha256 = "0a4jw02v50fzbnrqnldz9djzn37rric06lrg2vrkqikas9bfp394";
      name = "qtsvg-everywhere-src-6.6.1.tar.xz";
    };
  };
  qttools = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qttools-everywhere-src-6.6.1.tar.xz";
      sha256 = "0jliy2pz6czjw0ircd8h37a5prinm1a8dvnawwclxas5fdd10fa9";
      name = "qttools-everywhere-src-6.6.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qttranslations-everywhere-src-6.6.1.tar.xz";
      sha256 = "127f40wjm1q9clp2dj7vgyvv7nazb5c23akwgsr50wdd4bl051v6";
      name = "qttranslations-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtvirtualkeyboard-everywhere-src-6.6.1.tar.xz";
      sha256 = "1akvip4h86r5j898w1yx0mnfgc78b1yqfygk8h25z613vqvdwg4r";
      name = "qtvirtualkeyboard-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtwayland-everywhere-src-6.6.1.tar.xz";
      sha256 = "1cb8amr9kmr4gdnyi1mzriv34xf1nx47y91m9v6cczy05mijvk36";
      name = "qtwayland-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtwebchannel-everywhere-src-6.6.1.tar.xz";
      sha256 = "0hz5j6gpj4m74j74skj0lrjqmp30ns5s240gr6rrinisaz6qfq7i";
      name = "qtwebchannel-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtwebengine-everywhere-src-6.6.1.tar.xz";
      sha256 = "149nwwnarkiiz2vrgydz99agfc0z08lrnm4hr8ln1mjb44la4vks";
      name = "qtwebengine-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtwebsockets-everywhere-src-6.6.1.tar.xz";
      sha256 = "0hq6gg67x84fb6asfgx5jclvv1nqhr4gdr84cl27xn3nk0s18xbq";
      name = "qtwebsockets-everywhere-src-6.6.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.6.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.1/submodules/qtwebview-everywhere-src-6.6.1.tar.xz";
      sha256 = "0v1598ycj1rgphb00r3mwkij8yjw26g0d73w2ijf8fp97fiippnn";
      name = "qtwebview-everywhere-src-6.6.1.tar.xz";
    };
  };
}
