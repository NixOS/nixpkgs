# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qt3d-everywhere-src-6.4.0.tar.xz";
      sha256 = "1sxxxa6gaiy573j7x2k06dr4jsxbr9r1brcjfkn0zjgl46sbbgba";
      name = "qt3d-everywhere-src-6.4.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qt5compat-everywhere-src-6.4.0.tar.xz";
      sha256 = "1h54jiqkiipbb3i3sjznrinc67y76ld237qr17ald0pp6w45sivk";
      name = "qt5compat-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtactiveqt-everywhere-src-6.4.0.tar.xz";
      sha256 = "1pdam1ggxanrxr0pz8rap2ya59zyd4j56b9kfqbxm5kpkps345ar";
      name = "qtactiveqt-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtbase-everywhere-src-6.4.0.tar.xz";
      sha256 = "0zdkv7m98axjfpdmbv8v2xqndvhnanh75c7vgygw8rw5pnh7ar6b";
      name = "qtbase-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtcharts-everywhere-src-6.4.0.tar.xz";
      sha256 = "1ls077dhvkb4v7g2wwnb6v0rgg5fh4i2fx11fvzdlnsi4k7cmhr8";
      name = "qtcharts-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtconnectivity-everywhere-src-6.4.0.tar.xz";
      sha256 = "0kn52xibbp7a0021x6jznp9jxlf57fk85zba0z3lqqzanmyigp2s";
      name = "qtconnectivity-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtdatavis3d-everywhere-src-6.4.0.tar.xz";
      sha256 = "038591l0s9mkzxxxxm3knvyrk1vdimbp0gi5m26n79bx8lw01d0d";
      name = "qtdatavis3d-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtdeclarative-everywhere-src-6.4.0.tar.xz";
      sha256 = "10s35iivmafprw2spca6fw3gamf10lyp54376af9437srhpyfd1l";
      name = "qtdeclarative-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtdoc-everywhere-src-6.4.0.tar.xz";
      sha256 = "11j2vp2k3liz7388702ccy7fjb5ickhxnsc0iyiyirdmll187zgf";
      name = "qtdoc-everywhere-src-6.4.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qthttpserver-everywhere-src-6.4.0.tar.xz";
      sha256 = "10rlmpcj36qfr4465prpb515imrcfa6b2kiz16qyr8m4c86wb51i";
      name = "qthttpserver-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtimageformats-everywhere-src-6.4.0.tar.xz";
      sha256 = "0g2zjipayhzh0lwn6xgxw5mx6f5dpak75xszm2cg1h83bnvsf68l";
      name = "qtimageformats-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtlanguageserver-everywhere-src-6.4.0.tar.xz";
      sha256 = "09bhg3cm27d8imih1s7rk00zqwf863183znbzhhr3nkl6mqscy0q";
      name = "qtlanguageserver-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtlottie-everywhere-src-6.4.0.tar.xz";
      sha256 = "1d66fr2my8wcbalikppiykqwisflxahcl86zgqqy2s2wkv5bzz0w";
      name = "qtlottie-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtmultimedia-everywhere-src-6.4.0.tar.xz";
      sha256 = "0vvrgqcvvr6ch5vnmq3j3lx1xci21b8vc1fv24d9aamfgj28wbp8";
      name = "qtmultimedia-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtnetworkauth-everywhere-src-6.4.0.tar.xz";
      sha256 = "1cqp1z73d1kgnz5l5vvgxa58mfx61kdsr9xg1wgwrwbpzpw7g6v0";
      name = "qtnetworkauth-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtpositioning-everywhere-src-6.4.0.tar.xz";
      sha256 = "0d58zgjzdmi2fv8wbn0iz941mlpsxclcldzadwwhh0dbdmgmq6rd";
      name = "qtpositioning-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtquick3d-everywhere-src-6.4.0.tar.xz";
      sha256 = "1v0py2njivqbj0562pmwpfkqz1ylwkffsn7j943ky46lsih1c2pi";
      name = "qtquick3d-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtquick3dphysics-everywhere-src-6.4.0.tar.xz";
      sha256 = "01zx50f5gmvwg2mb853hsr2hgrciyg62h365ryq5y9fi6hs48nfw";
      name = "qtquick3dphysics-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtquicktimeline-everywhere-src-6.4.0.tar.xz";
      sha256 = "0msg0l75m0slwar9p3vpx99cyf3j3mfbajfra26jmi0haf5s5s3h";
      name = "qtquicktimeline-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtremoteobjects-everywhere-src-6.4.0.tar.xz";
      sha256 = "1kp1as4ih021dz37z53nv7s2byb4w04cxpj4qkxqdvvgxvmps6pm";
      name = "qtremoteobjects-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtscxml-everywhere-src-6.4.0.tar.xz";
      sha256 = "0r3nv4bbdab8hsvzz0d03qq977smlfmp7k4wm6n2jj2rwsjp61yl";
      name = "qtscxml-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtsensors-everywhere-src-6.4.0.tar.xz";
      sha256 = "1njhrbhknbil8dllknc8p3q16k65rmqdx1gkhlcn6qlzbcphg37k";
      name = "qtsensors-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtserialbus-everywhere-src-6.4.0.tar.xz";
      sha256 = "14ga962x9h5rkgybf63b4b4fn8i96c0z9q60ns2ml20jgikmbjpg";
      name = "qtserialbus-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtserialport-everywhere-src-6.4.0.tar.xz";
      sha256 = "10s4997n3b0vp51slrjcdkkfqf8kabcn8ypz5gl2h8nfhygcqj7i";
      name = "qtserialport-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtshadertools-everywhere-src-6.4.0.tar.xz";
      sha256 = "141vmracfa9r71l0mqilgllfb3c1ygpc913yx8pwsy411vqabmnv";
      name = "qtshadertools-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtspeech-everywhere-src-6.4.0.tar.xz";
      sha256 = "1xrx323vyvrgrphxvf3nxy8s7ps26pgxaj71rlgipl58jqhc4fw7";
      name = "qtspeech-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtsvg-everywhere-src-6.4.0.tar.xz";
      sha256 = "09av5ky5zlsz4smf3xwvk07ylkz1wz3g5hbx73xdqx6h6yaaxz83";
      name = "qtsvg-everywhere-src-6.4.0.tar.xz";
    };
  };
  qttools = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qttools-everywhere-src-6.4.0.tar.xz";
      sha256 = "18pv3b0y9ycbn5v98rjir8wsvsy40vy8xc5pyylfg2s5ikwdbwwp";
      name = "qttools-everywhere-src-6.4.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qttranslations-everywhere-src-6.4.0.tar.xz";
      sha256 = "0pwjfsi4b4fr2hw9mx76fiix0mz0wss3ic4pmd9yngk91f9kmfbs";
      name = "qttranslations-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtvirtualkeyboard-everywhere-src-6.4.0.tar.xz";
      sha256 = "087xlc7ljkbmm85n42qx0cz8rvyhfkw1dzypxp5h3c5glamhkar5";
      name = "qtvirtualkeyboard-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtwayland-everywhere-src-6.4.0.tar.xz";
      sha256 = "1z32bdgcril9ijqsn4d60znm610mm72rgn1a6dblvhxy9zhsi2zh";
      name = "qtwayland-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtwebchannel-everywhere-src-6.4.0.tar.xz";
      sha256 = "0nk92cbdph5ri91pnh54i3bdpx1pn9pbgyysmpg59265gj1nv3sj";
      name = "qtwebchannel-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtwebengine-everywhere-src-6.4.0.tar.xz";
      sha256 = "00skwxlin6za8wsh6ddhy7nmpabzjzj1lxf2w81fj04vb7nfjak6";
      name = "qtwebengine-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtwebsockets-everywhere-src-6.4.0.tar.xz";
      sha256 = "1jlvxidjaj44hky1cwm0y8gj6zynrnd70hf44dhjcdv5rllncg7z";
      name = "qtwebsockets-everywhere-src-6.4.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.4.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.4/6.4.0/submodules/qtwebview-everywhere-src-6.4.0.tar.xz";
      sha256 = "19z5d1gs6jm2776si9i3dxn4j70y3s8yh3m299gvb2b8fby8xfwl";
      name = "qtwebview-everywhere-src-6.4.0.tar.xz";
    };
  };
}
