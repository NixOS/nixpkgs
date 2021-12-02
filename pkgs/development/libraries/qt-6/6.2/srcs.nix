# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/6.2
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qt3d-everywhere-src-6.2.2.tar.xz";
      sha256 = "1bcnyfp888spc07c9x5arynghv5a5w9s22k087fy46qmiw28hl6f";
      name = "qt3d-everywhere-src-6.2.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qt5compat-everywhere-src-6.2.2.tar.xz";
      sha256 = "1bbb4xwrpmhsh4yf1gmiw8lqiacsnwv0l38vqapyb68xvzck7fx5";
      name = "qt5compat-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtactiveqt-everywhere-src-6.2.2.tar.xz";
      sha256 = "1yqk32jkpk0qwwgrlxw2d91qcc5yj8hj8rifqc14p5xmfc7nsflw";
      name = "qtactiveqt-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtbase-everywhere-src-6.2.2.tar.xz";
      sha256 = "06ic4gkyg8wizp6alq3jzpwg4sbab9nlrbhirn2aybhc32093aw5";
      name = "qtbase-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtcharts-everywhere-src-6.2.2.tar.xz";
      sha256 = "0ykfy5h48dr91xdjjs7ggz3bdz1c4hxy3r6cjaca0lxg6d275zlg";
      name = "qtcharts-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtconnectivity-everywhere-src-6.2.2.tar.xz";
      sha256 = "1v2w7ndb6ip8a31jrs0mhh50cvrywnazlqd1vv700yls09nr2vmv";
      name = "qtconnectivity-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtdatavis3d-everywhere-src-6.2.2.tar.xz";
      sha256 = "08zifbc5brqiiyw29g0s5bbj19vrmpsmcy3jqb1ys4bcx18xz51k";
      name = "qtdatavis3d-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtdeclarative-everywhere-src-6.2.2.tar.xz";
      sha256 = "0a6g8b3n47rbv82ccpfaz5ccn6aphs8q63gdzph584xkj80fy10s";
      name = "qtdeclarative-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtdoc-everywhere-src-6.2.2.tar.xz";
      sha256 = "0bj463g2kimxvbb0gs3d6jskg97vw9n0z3s7xfvdyk9k8p43bjfm";
      name = "qtdoc-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtimageformats-everywhere-src-6.2.2.tar.xz";
      sha256 = "0ryjbfhn62c2cwlpc8v3ddsvm7f50vprahjkzxr0v9wi4danskr1";
      name = "qtimageformats-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtlottie-everywhere-src-6.2.2.tar.xz";
      sha256 = "0kyp1ycjhqvbx4szfjnfb9kb9nv574g3r7zd27961j2xkwdwjalw";
      name = "qtlottie-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtmultimedia-everywhere-src-6.2.2.tar.xz";
      sha256 = "042896vl8djvyc6i394z3z0jri6n8p99n1g5xs38x0aswgkq9v1p";
      name = "qtmultimedia-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtnetworkauth-everywhere-src-6.2.2.tar.xz";
      sha256 = "1qg90ngz1n3bq5a358n7ag2j0hl6h7br5k5b7xnfkfb705s7q8f8";
      name = "qtnetworkauth-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtpositioning-everywhere-src-6.2.2.tar.xz";
      sha256 = "16m01dxaadlg9rkhn5vcq0wd79p8ps5yhdmj22ahi0z3x92ia8r6";
      name = "qtpositioning-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtquick3d-everywhere-src-6.2.2.tar.xz";
      sha256 = "0jrnnm45ikkhsp3yqpvaspxywy4li6c8s8zxxl2jzjw4dsizhzmy";
      name = "qtquick3d-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtquicktimeline-everywhere-src-6.2.2.tar.xz";
      sha256 = "0yflxwhgyc262fnsglk34ykax3k8r570hglvcvfp9ximn1wm97ck";
      name = "qtquicktimeline-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtremoteobjects-everywhere-src-6.2.2.tar.xz";
      sha256 = "0vp69ac59nv94j3cvw27bwbqb3fw3gimvjikzdy4xfxxkzcysv7m";
      name = "qtremoteobjects-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtscxml-everywhere-src-6.2.2.tar.xz";
      sha256 = "1vcjgsvlpqw0mrq7fqgyxz2c0j5w85i12cw8yhn561j1bs6467dp";
      name = "qtscxml-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtsensors-everywhere-src-6.2.2.tar.xz";
      sha256 = "1i64864vz6bx3l1cyrb00mgw4irlr5r3lv7dqi90n5hfqmxbsj91";
      name = "qtsensors-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtserialbus-everywhere-src-6.2.2.tar.xz";
      sha256 = "0ww4dsdsa5cygasaw1mbfviyxjchazy5j94b57kk4fr1bjdd45gs";
      name = "qtserialbus-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtserialport-everywhere-src-6.2.2.tar.xz";
      sha256 = "02k4z6f2zyy10f0dlj11bvkbc65rl9cag0akjmyhry9d6ghalmam";
      name = "qtserialport-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtshadertools-everywhere-src-6.2.2.tar.xz";
      sha256 = "1rc9dasw8ikzmyzaaxavlsg2nyj9nfjskhri44mgmhaq4gkhaxgr";
      name = "qtshadertools-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtsvg-everywhere-src-6.2.2.tar.xz";
      sha256 = "0xdx38cpmd4f33g1w47lfdh7mxii0h3b0f3sffy6hr515y9n7gg1";
      name = "qtsvg-everywhere-src-6.2.2.tar.xz";
    };
  };
  qttools = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qttools-everywhere-src-6.2.2.tar.xz";
      sha256 = "1lgcjixb9hqkbd2ml1p2kj96icsiiygwvd8wd8j23v0a9b5jwm60";
      name = "qttools-everywhere-src-6.2.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qttranslations-everywhere-src-6.2.2.tar.xz";
      sha256 = "13scx7c68gxwg6bxwingrjj9lwqwaimqpz3ybq1k16bf9hi494pw";
      name = "qttranslations-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtvirtualkeyboard-everywhere-src-6.2.2.tar.xz";
      sha256 = "19b10n3w58wx7w0jk5vz28q6hbipy7p1xs58b1l965z70fkw2wwr";
      name = "qtvirtualkeyboard-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtwayland-everywhere-src-6.2.2.tar.xz";
      sha256 = "061nxf6rvqi4h0z066dvb448006pklvkv2wk7i4wkn5mxjrm4did";
      name = "qtwayland-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtwebchannel-everywhere-src-6.2.2.tar.xz";
      sha256 = "0igq9f3zfydzmf932pr3ygz7f5r6wwf8qgy9107d82nci55dgqrj";
      name = "qtwebchannel-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtwebengine-everywhere-src-6.2.2.tar.xz";
      sha256 = "1d6k3i45xhh03w7k6irvz1hzn8ryny2yb9h389pak3k7wkkcsb9d";
      name = "qtwebengine-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtwebsockets-everywhere-src-6.2.2.tar.xz";
      sha256 = "0xi09h1qydjf1gdqrk7w6v9w523l0dhcg0r8n85inx561nzshiw8";
      name = "qtwebsockets-everywhere-src-6.2.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.2.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.2/6.2.2/submodules/qtwebview-everywhere-src-6.2.2.tar.xz";
      sha256 = "09cnsr77f5mia53kq4w1zr91liyy4jrsd61b0ckkhl7ls18g84fj";
      name = "qtwebview-everywhere-src-6.2.2.tar.xz";
    };
  };
}
