# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qt3d-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0v3wsqn6ig8n0k7f745rnxy6n2ykf394fafszxxzfb9vffi46867";
      name = "qt3d-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qt5compat-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "19rfk1wp32zfaf6g2a2gz7xiijhxfp02x36gxdw00f5h9wcqd9l7";
      name = "qt5compat-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtactiveqt-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "065524hn4c3c2dms9dcvazsq09ikvz5gz8vzbrfas4z99j8hzj6k";
      name = "qtactiveqt-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtbase = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtbase-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1q0p0m3g7j569bcsyqqvypnwsipcmy4bcma8s16g1783g1gc23dd";
      name = "qtbase-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtcharts-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1zcipb58a7hcsqaal95f0xccpb645q9s7lxzd69brycfl0ap7dlk";
      name = "qtcharts-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtconnectivity-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "015igd1f8r5nvqm6yviy6wlka945b6kxn5npz4xvhjip6bvvmqfd";
      name = "qtconnectivity-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtdatavis3d-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1bp9nkn7n1nr7bzx540x9gc4g1iwpli80qq48sw4vqy5wk2hkwgb";
      name = "qtdatavis3d-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtdeclarative-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "09w1w9zzp0y1i7f5gk642vpf90wc28613znz5l2423jk0rwfblgq";
      name = "qtdeclarative-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtdoc-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0zaqbk76s6b1bgpsrkgjqlqf0mav93sgmvlbrn4l9b2gl0b1vf23";
      name = "qtdoc-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtgraphs-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1ygzxpjaqiyfakbvv012rw1i5j7brnxj64jilsbf30v7irg9njyq";
      name = "qtgraphs-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtgrpc-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1pdd03q89h59g8kbspryxi07brf13a617zs3v0wi1vi17bz5x0za";
      name = "qtgrpc-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qthttpserver-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "18l0iaq4hmcz15g9skanmb2zdjfkks90gfvcmfzbs9wsqcvqq5w8";
      name = "qthttpserver-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtimageformats-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "17a4382ni873jwnlc3hlx4k07knipsczpcyvq40qqrh8x391d2hg";
      name = "qtimageformats-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtlanguageserver-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0hckqk5l42gj6x1wisvixwl0v3xh67ik6jlnx2k4604wdk3dz86x";
      name = "qtlanguageserver-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtlocation-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "108wysb156zfm2m18m9mfn7260i5kn9zfvna4f6c3c59xz2nnw2d";
      name = "qtlocation-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtlottie-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "05mh8ynffihx0i156az6rdn46dk2lfszrpa9c85w1nx5d0325fp8";
      name = "qtlottie-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtmultimedia-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "04hxizfvlvs8v9gp0jxj9nrin51n9cvw3w8r36vhjrrphw4fx2vd";
      name = "qtmultimedia-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtnetworkauth-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "04psn506axmb5i52qmaj2c54as39ppwc60msz4bv0drc63kpnrxh";
      name = "qtnetworkauth-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtpositioning-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1pf4gmmxjs2h6cp7bxl3v9ndj12nhmbpv4wmxkv9rfpj17iqxyw0";
      name = "qtpositioning-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtquick3d-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1613j4srqwd7h01wvdacqn4xcsibwgrll36x2ss5wd3v5cqg5gsy";
      name = "qtquick3d-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtquick3dphysics-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "03zigkwia1waf5vgjy0j5sr8776a8bafi1dybgpi5dx447vdk672";
      name = "qtquick3dphysics-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtquickeffectmaker-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0zpqgayh56q9pzah704kwdwiqmdj5xsvviaw0nsf93dqaqw9s47m";
      name = "qtquickeffectmaker-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtquicktimeline-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "135malvqxrxbajmilw3vj1ppkwfv16azf86mb3x6h7cpv5a7j9sn";
      name = "qtquicktimeline-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtremoteobjects-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "11jaf2g63wvmabqv57iq16a1dj1kr8wb97mbxb5v2ha34sj9nca3";
      name = "qtremoteobjects-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtscxml-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "195djn63df2fyyrla0n096m7gkyq4igz7nsp00r5vridfvns8sx0";
      name = "qtscxml-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtsensors-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1vswvlgpirb4xx1wvvc84ba6f5iwdpafj4iqpb6y93s27dls0jgb";
      name = "qtsensors-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtserialbus-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0nq69h9n3r80vl965rwjdyhy36hmapizj4ap6z910rsrqfb1arcb";
      name = "qtserialbus-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtserialport-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1yxdj66wmy4g3a79xhsgr543fj6hlmic7p4z48cwv2h2nbpc8r9w";
      name = "qtserialport-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtshadertools-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1z96swxd799c6655h8p7j6alhrckmxs1sj0dnjhs72smhrp13ggc";
      name = "qtshadertools-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtspeech-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1qa1sdk4ikypp4ijh4phm9apc0yamrjkdcyix89v66f4ahsmj0h2";
      name = "qtspeech-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtsvg-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1f19avx8qmn4rw8haqx5p36aqfkmgs2xm587ps4dr4ynymmi47l4";
      name = "qtsvg-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qttools = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qttools-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0cfzdcgbxn3vir0b4qqrscjjiqaimhd73adhijgsz4pa5qkc8npl";
      name = "qttools-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qttranslations-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1bkzzgid3ymcmkjnm7vszfifxbhf84vqn0shl80j5qawm6qb19ig";
      name = "qttranslations-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtvirtualkeyboard-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1jvsg8pph9z6rhfwrvqlfcizx88ibi4g0px1hvscqcks062vdgd2";
      name = "qtvirtualkeyboard-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtwayland-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "044xd91zlcacxccgcawmlz2y6jbvxjh687c873ncr42qbfz3czqi";
      name = "qtwayland-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtwebchannel-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "03dfvxgqa869wlms3v4vcq493yazj3lbh3h7lbyygvsg41zrqd6j";
      name = "qtwebchannel-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtwebengine-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1adrx6azgwfmvfp26fbhpsjpbpc0cshm8k9qa3q4nv9z25gim7na";
      name = "qtwebengine-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtwebsockets-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "1ah19rci90jm6n7ph0p5lx9z49ng98cqp3s3k47mbdivk1ccjfvs";
      name = "qtwebsockets-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.7.0-rc2";
    src = fetchurl {
      url = "${mirror}/development_releases/qt/6.7/6.7.0-rc2/submodules/qtwebview-everywhere-src-6.7.0-rc2.tar.xz";
      sha256 = "0nx7irihrsnm8wdqjk8dnf8spfw6j90pdkdmmxhv2qq2zpwklyy3";
      name = "qtwebview-everywhere-src-6.7.0-rc2.tar.xz";
    };
  };
}
