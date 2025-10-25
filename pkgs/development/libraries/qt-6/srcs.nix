# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qt3d-everywhere-src-6.9.3.tar.xz";
      sha256 = "1zvzc88gykbqmks5q06zl9113lvy07gxsxmzmvpd8y8sybfn91ky";
      name = "qt3d-everywhere-src-6.9.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qt5compat-everywhere-src-6.9.3.tar.xz";
      sha256 = "0qa4s1m9f0qzs6msrilpi12wv5hpkgw211s0cqsiqaf24hhsq789";
      name = "qt5compat-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtactiveqt-everywhere-src-6.9.3.tar.xz";
      sha256 = "1kzc0pqwyi1h1s8qk8agplfkrib2s9cg7bwpl41z8icngwj76h6v";
      name = "qtactiveqt-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz";
      sha256 = "0vnwp12wvsab1vsn8zhi4mcvrpg5iacq59xzzs0w0vimc3va58f5";
      name = "qtbase-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtcharts-everywhere-src-6.9.3.tar.xz";
      sha256 = "0lsckms5s0av6dy8mll7bnspsigz6hpvbddm79n2wshxnfywpmr9";
      name = "qtcharts-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtconnectivity-everywhere-src-6.9.3.tar.xz";
      sha256 = "1xfp3p5xkypxfgzvq2a5zcnyc7ms5gav99z5qmb48k0pzdgbl6z2";
      name = "qtconnectivity-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtdatavis3d-everywhere-src-6.9.3.tar.xz";
      sha256 = "1v5zdwjpz8j7s1nrkg7sp452vmdmhq09kdxvbsya2ad6jsw4ajxa";
      name = "qtdatavis3d-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtdeclarative-everywhere-src-6.9.3.tar.xz";
      sha256 = "0q52z2iiqdchsvvcs7w6mq38v0ahv2h5jyvbjxfbzbr9f8i1n1ss";
      name = "qtdeclarative-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtdoc-everywhere-src-6.9.3.tar.xz";
      sha256 = "0am13lnmfxqj8ayx9ml5sm2qagl5s6hrki3bvdxfmzfkl07ds694";
      name = "qtdoc-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtgraphs-everywhere-src-6.9.3.tar.xz";
      sha256 = "13041r244h3mgs95zcyw5x7lfginf4gxs59spz030p0jap867p2h";
      name = "qtgraphs-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtgrpc-everywhere-src-6.9.3.tar.xz";
      sha256 = "00py189v3ihpy9cj51sxapl2dp3ci7k04ikjl6zbxmbjrdwwhqvr";
      name = "qtgrpc-everywhere-src-6.9.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qthttpserver-everywhere-src-6.9.3.tar.xz";
      sha256 = "13rfvmh42h4zd2slb2d0xqdy7wgsy05q8jqy3ldbikx5vf9qg9vs";
      name = "qthttpserver-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtimageformats-everywhere-src-6.9.3.tar.xz";
      sha256 = "1zigaz2418sy6m3na91rddxvlfn3257535kq120f9f6lzgdnpcjg";
      name = "qtimageformats-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtlanguageserver-everywhere-src-6.9.3.tar.xz";
      sha256 = "0cwx6rlp9nm0qbzjamfcqhhylbmh2f5kk3z749ln49fbz32ads68";
      name = "qtlanguageserver-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtlocation-everywhere-src-6.9.3.tar.xz";
      sha256 = "018nwyr1idh3rfp22w86pw3i25xbj7mv49wir5s1akmgzp8jf4hl";
      name = "qtlocation-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtlottie-everywhere-src-6.9.3.tar.xz";
      sha256 = "0cyzj0xhdhlgkra1pqb4vdazxjfii05sc7r5h0ml9fzhfiai0vhi";
      name = "qtlottie-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtmultimedia-everywhere-src-6.9.3.tar.xz";
      sha256 = "1xc6kgqm88rkzr8qzdi8yj8dm4dqfsfzkkba4d8iijb0xbkvwxd2";
      name = "qtmultimedia-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtnetworkauth-everywhere-src-6.9.3.tar.xz";
      sha256 = "1ivyrha9ibc2iz4lvrz5309pdqxyccwzbpmyg2m24ghkxm3xrnb7";
      name = "qtnetworkauth-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtpositioning-everywhere-src-6.9.3.tar.xz";
      sha256 = "1d1mb1fni42vgfyj9ghk0g6602nx8lwa1y0bmynpmh84yy0ck1qc";
      name = "qtpositioning-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtquick3d-everywhere-src-6.9.3.tar.xz";
      sha256 = "0wyfran9vwl6fm2i9nc149fpvv8r5k3yvrn2f1rjpb9qkw271cli";
      name = "qtquick3d-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtquick3dphysics-everywhere-src-6.9.3.tar.xz";
      sha256 = "0vjs7calgc0vc7fv6hnbghhi37cfiapxim650av9w92xfhnv5myw";
      name = "qtquick3dphysics-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtquickeffectmaker-everywhere-src-6.9.3.tar.xz";
      sha256 = "04lrlp1fakn8kv160ln8j1fsqsfdcjf1dzwlknx5r1m04hfkdw3b";
      name = "qtquickeffectmaker-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtquicktimeline-everywhere-src-6.9.3.tar.xz";
      sha256 = "1xqidk7njn1xiiz3i27ddzwd568caigq8p2ja4ks67x7bsk4nkr8";
      name = "qtquicktimeline-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtremoteobjects-everywhere-src-6.9.3.tar.xz";
      sha256 = "0nyqmapypw0y745zg58rq9183vcrbm2c71dc3p9sdqflal07r64q";
      name = "qtremoteobjects-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtscxml-everywhere-src-6.9.3.tar.xz";
      sha256 = "1drlbdgicqx76gyqi79ri1gy2vrya6l99gig76p8x46za70c12gk";
      name = "qtscxml-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtsensors-everywhere-src-6.9.3.tar.xz";
      sha256 = "0s1gz66nar27c3l5cbqqdnza1pxbd7nylz88mnj32xpkwml53nx2";
      name = "qtsensors-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtserialbus-everywhere-src-6.9.3.tar.xz";
      sha256 = "1ksvfwfk0az47sgfcaqbac936y75lcaga5fip5lbgz0s0zd3k08a";
      name = "qtserialbus-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtserialport-everywhere-src-6.9.3.tar.xz";
      sha256 = "16427sa9qhk8hsyxjr69fhqmvzlg9n4pdizmqfc4cr7j1w1yq62b";
      name = "qtserialport-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtshadertools-everywhere-src-6.9.3.tar.xz";
      sha256 = "0rs553abb8sdla4cywfpgfh3vvyafm8spy8nnvj06md3hvp09632";
      name = "qtshadertools-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtspeech-everywhere-src-6.9.3.tar.xz";
      sha256 = "0gmbr65s4j2bka13iln3fmjrhl1i46lp5vlhdv66rf1gfi65lvzq";
      name = "qtspeech-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtsvg-everywhere-src-6.9.3.tar.xz";
      sha256 = "1qi6f3lvp0r7n79m1iw80690366bd53gyxm5gp76zgnbb0rslxnv";
      name = "qtsvg-everywhere-src-6.9.3.tar.xz";
    };
  };
  qttools = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qttools-everywhere-src-6.9.3.tar.xz";
      sha256 = "1sdla2blvk9r4g7v67dhwqjxx7kflyh7cm9pw5f7ziazjw7apxqc";
      name = "qttools-everywhere-src-6.9.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qttranslations-everywhere-src-6.9.3.tar.xz";
      sha256 = "18chqjzy7ji76crfisl1rya8ds3my97bgsxkg7yldcc1crg58vgk";
      name = "qttranslations-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtvirtualkeyboard-everywhere-src-6.9.3.tar.xz";
      sha256 = "0d2m87fvd11ckjjzy3lj1mbfisig4x9c263phq4fczwy3k4xb851";
      name = "qtvirtualkeyboard-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtwayland-everywhere-src-6.9.3.tar.xz";
      sha256 = "1pfsfdjqw985d8220jw13sqacyiip26bzpk1ax30ms33jayd84z4";
      name = "qtwayland-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtwebchannel-everywhere-src-6.9.3.tar.xz";
      sha256 = "01d3dy0fjz4vfy8s1yzpmd31b8mhvqf15z61fzr9qgd1wp0vnmwl";
      name = "qtwebchannel-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtwebengine-everywhere-src-6.9.3.tar.xz";
      sha256 = "0rl9v936sq6spvb3sfkpmc51wwmljrn4ssy3ii0pdn0xsl8kn2ym";
      name = "qtwebengine-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtwebsockets-everywhere-src-6.9.3.tar.xz";
      sha256 = "1i428awzws4x4cmv6zpdgb27c2m71cs8dqcjbwiwqcfbyf6dlzg2";
      name = "qtwebsockets-everywhere-src-6.9.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.9.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.3/submodules/qtwebview-everywhere-src-6.9.3.tar.xz";
      sha256 = "1j1cqj2hq0c8r9lxb1h6mdhnf9clqb95jw2p0nn81jzin701ypn6";
      name = "qtwebview-everywhere-src-6.9.3.tar.xz";
    };
  };
}
