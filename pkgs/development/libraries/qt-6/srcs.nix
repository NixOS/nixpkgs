# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qt3d-everywhere-src-6.10.0.tar.xz";
      sha256 = "1dz9g3nlwgwfycwl5a0c7h339s7azq2xvq99kd76wjqzfkrmz25x";
      name = "qt3d-everywhere-src-6.10.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qt5compat-everywhere-src-6.10.0.tar.xz";
      sha256 = "0zibn0kq8grlpkvfasjciz71bv6x4cgz02v5l5giyplbcnfwa9fh";
      name = "qt5compat-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtactiveqt-everywhere-src-6.10.0.tar.xz";
      sha256 = "15m7g4h4aa3fk5q4an3apd0bdqkxdknnx64p72brrmah773mmlpm";
      name = "qtactiveqt-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtbase-everywhere-src-6.10.0.tar.xz";
      sha256 = "0v84f9pw387m0ghd4n6s9ipwjvniqspabqxkqmbj58slrcxn5m7a";
      name = "qtbase-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtcharts-everywhere-src-6.10.0.tar.xz";
      sha256 = "0svz8frryxv811xyg8cawn5icjcin6909mw4k6hlvgz7429m5zqv";
      name = "qtcharts-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtconnectivity-everywhere-src-6.10.0.tar.xz";
      sha256 = "16gs86zyaq8rvzd9jribgg51hanas15gpy8zh45n58004v7xa2jn";
      name = "qtconnectivity-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtdatavis3d-everywhere-src-6.10.0.tar.xz";
      sha256 = "1qinrrk1j9qknwq2x7rl9aw8ajrp1h7kpfg29wcvaklbz9jj5xpx";
      name = "qtdatavis3d-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtdeclarative-everywhere-src-6.10.0.tar.xz";
      sha256 = "1c7nar7q92w8l7wkmwbl0f6j4g1c8kw8jbn1bf35sf821593bzbf";
      name = "qtdeclarative-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtdoc-everywhere-src-6.10.0.tar.xz";
      sha256 = "0fvx690kap3s2h9lg4d4w3nsiks6h2idggskisg1r1gpwks2brgc";
      name = "qtdoc-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtgraphs-everywhere-src-6.10.0.tar.xz";
      sha256 = "1shllyk4f5lidw0hij9zhgapck3rf3hm6qw4m1nn79mynfrz3j3f";
      name = "qtgraphs-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtgrpc-everywhere-src-6.10.0.tar.xz";
      sha256 = "0id4j4xgamx9wndc3cgnf5m42ax257xyfy2khq4aw0b10s4j4wpv";
      name = "qtgrpc-everywhere-src-6.10.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qthttpserver-everywhere-src-6.10.0.tar.xz";
      sha256 = "1i8z4l1is5xashh5lq9afj1syhvvz15zgcr5f27mwhjzvc0mfw74";
      name = "qthttpserver-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtimageformats-everywhere-src-6.10.0.tar.xz";
      sha256 = "1shcghzjn3v9mbgms0ykk5d91q7hdm8mxv8n6vjhsm3wa190lib4";
      name = "qtimageformats-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtlanguageserver-everywhere-src-6.10.0.tar.xz";
      sha256 = "19i151qxh2fw2h5w6082bh0myk6skz3dihhs4mahhb1rkzh077jc";
      name = "qtlanguageserver-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtlocation-everywhere-src-6.10.0.tar.xz";
      sha256 = "007qbni20qajdq6villwp7bc7hqzjlppc30yw3ccqb2bzf3kxm6b";
      name = "qtlocation-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtlottie-everywhere-src-6.10.0.tar.xz";
      sha256 = "09bvm3jr2s0hg14dq8b7604hfgxj3cm1i93lkkbjh2n2bfpi793h";
      name = "qtlottie-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtmultimedia-everywhere-src-6.10.0.tar.xz";
      sha256 = "09hixwp8sq771rfp4c8bvmpzl6jd906k2rsrkxwij78drwhl0hh4";
      name = "qtmultimedia-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtnetworkauth-everywhere-src-6.10.0.tar.xz";
      sha256 = "1j5k6dn0zc5rq82k89nyz5w0ny89mg1pg5aw0h41ybg2f5fqaq04";
      name = "qtnetworkauth-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtpositioning-everywhere-src-6.10.0.tar.xz";
      sha256 = "1q8yd9sjbm1vzcda1i21x0qf0n4md0k6wwbmr5jrvqbbcf8brgzc";
      name = "qtpositioning-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtquick3d-everywhere-src-6.10.0.tar.xz";
      sha256 = "126lxiizd4pxxp43zzwv3k4i73806bgg329qsygz5qbnm0g8q9cq";
      name = "qtquick3d-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtquick3dphysics-everywhere-src-6.10.0.tar.xz";
      sha256 = "0hj90pdxh6x6zm1b4iflhr89sy13qrbwc79pv9z9m7gdwyzhid62";
      name = "qtquick3dphysics-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtquickeffectmaker-everywhere-src-6.10.0.tar.xz";
      sha256 = "0vmr5s6b4cqxpw5kl5shzydj3if89znm3izj5nrhzsgbic11vhk4";
      name = "qtquickeffectmaker-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtquicktimeline-everywhere-src-6.10.0.tar.xz";
      sha256 = "182bn72mifx8s867hsmramjfl9qr8szpla9fqw7bi3ywb1fiig6z";
      name = "qtquicktimeline-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtremoteobjects-everywhere-src-6.10.0.tar.xz";
      sha256 = "1616dagpzs68rhi1wiq1dwl1kbgf2c1mmrb3c7ni204k0rcjsh5i";
      name = "qtremoteobjects-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtscxml-everywhere-src-6.10.0.tar.xz";
      sha256 = "1r1ic7kr3xzrg0vyrj4smj2vzyidazwrb5jqn2l6irg1bx06r55m";
      name = "qtscxml-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtsensors-everywhere-src-6.10.0.tar.xz";
      sha256 = "0fc7cq067sddfwcn43j5v4h6xzjrvj5gvi08l9bfag43s4d5wlk7";
      name = "qtsensors-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtserialbus-everywhere-src-6.10.0.tar.xz";
      sha256 = "0c7cljc555vcs7jkm63mczxxpg085b161b6vpd9vnrz2zyzv49y6";
      name = "qtserialbus-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtserialport-everywhere-src-6.10.0.tar.xz";
      sha256 = "01gqv6hc2ycd877jhq6ffnfgizh9pgnzc1gn6m6cfp8ximwa07jg";
      name = "qtserialport-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtshadertools-everywhere-src-6.10.0.tar.xz";
      sha256 = "1xpvzmpisglbk3nnczqvj0n1dv6zd79phvczqwpqc9yq7y64gfl7";
      name = "qtshadertools-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtspeech-everywhere-src-6.10.0.tar.xz";
      sha256 = "07m59akg31010khz82lvbrgjwwacavra5qsi17jqpk0chdk300qk";
      name = "qtspeech-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtsvg-everywhere-src-6.10.0.tar.xz";
      sha256 = "0cr5vaz485n23fvw4kvh1ykqny61bpdr5vd2q9szywsy9phc1ljy";
      name = "qtsvg-everywhere-src-6.10.0.tar.xz";
    };
  };
  qttools = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qttools-everywhere-src-6.10.0.tar.xz";
      sha256 = "0anhvd7yqs9l3dryl43f0f7zq22rwrvz93g16ygmjgiyryc50vfq";
      name = "qttools-everywhere-src-6.10.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qttranslations-everywhere-src-6.10.0.tar.xz";
      sha256 = "1pkc0a5kigcp0jcq3ny1ykl0rqw0vabz45w14d2mgjyhrx9q4vij";
      name = "qttranslations-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtvirtualkeyboard-everywhere-src-6.10.0.tar.xz";
      sha256 = "108klc6cr2ihaka9gnqaqv9i8r4lr8m39yviic3nviibd3r6gcmb";
      name = "qtvirtualkeyboard-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtwayland-everywhere-src-6.10.0.tar.xz";
      sha256 = "07vnfd0xmzg8vc68g9j2i88lilmic5vhv22gn47vs94v4l52ngv0";
      name = "qtwayland-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtwebchannel-everywhere-src-6.10.0.tar.xz";
      sha256 = "02ahm7cz8wgvfcgyq85sc2v566x4ihymalmv5xi0wn5zz9j5h5kl";
      name = "qtwebchannel-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtwebengine-everywhere-src-6.10.0.tar.xz";
      sha256 = "0765a5kfkxxi7rq58pivi32xwb17pvg3h2ix88dx3y9h3jqpfk64";
      name = "qtwebengine-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtwebsockets-everywhere-src-6.10.0.tar.xz";
      sha256 = "0vl091wnzqjpnp0i0l2dqlbhlwcfzw2ry1p48aifxf63lmyjw2fi";
      name = "qtwebsockets-everywhere-src-6.10.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.10.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.0/submodules/qtwebview-everywhere-src-6.10.0.tar.xz";
      sha256 = "03rszbcr3lnf9cnk7hz99ibxx8na4l3i98q19fahj36ilpk68dd9";
      name = "qtwebview-everywhere-src-6.10.0.tar.xz";
    };
  };
}
