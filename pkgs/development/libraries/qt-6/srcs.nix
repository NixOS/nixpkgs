# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qt3d-everywhere-src-6.6.0.tar.xz";
      sha256 = "0apwq6cqxn1xszhaawrz14yyy9akbmh6i5yys3v74kbz4537ma0d";
      name = "qt3d-everywhere-src-6.6.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qt5compat-everywhere-src-6.6.0.tar.xz";
      sha256 = "1jlg3b3jn7m2gih892vcsv36rm430g86rz6bdlk15xr6c6vfv19x";
      name = "qt5compat-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtactiveqt-everywhere-src-6.6.0.tar.xz";
      sha256 = "17ks2sggvx7p7hmg128w494n06nzyf7r5i04nykhmhqlx71wnm6j";
      name = "qtactiveqt-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtbase-everywhere-src-6.6.0.tar.xz";
      sha256 = "03lysc6lp17hyjrwvp0znw02bdysrff8rlsb0nlrfn6b58qm7783";
      name = "qtbase-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtcharts-everywhere-src-6.6.0.tar.xz";
      sha256 = "1x9c55j8yscb6q18haspqnnvbc6pcgdv5ljrhj0ijxqcqz6spgp6";
      name = "qtcharts-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtconnectivity-everywhere-src-6.6.0.tar.xz";
      sha256 = "04203igj3fnmw1i7k291j3p987qssss3hz58kjdz33n28xic4a8w";
      name = "qtconnectivity-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtdatavis3d-everywhere-src-6.6.0.tar.xz";
      sha256 = "17jrs6mh741vfgj8bgkahfzj2xaa7agw9s6q2xcv9s8bkxnryj60";
      name = "qtdatavis3d-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtdeclarative-everywhere-src-6.6.0.tar.xz";
      sha256 = "0cd3gxyklhscq2zymhmv6j4pzgrl0gpx8yyhgwqg1j0qm6q9nlqv";
      name = "qtdeclarative-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtdoc-everywhere-src-6.6.0.tar.xz";
      sha256 = "07i6fxczbpma344jgmpcb1y24jlm136y7b698b57ipcvgbc38xnk";
      name = "qtdoc-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtgraphs-everywhere-src-6.6.0.tar.xz";
      sha256 = "0zsyw5w15xzmaap0r396jpsz7synq5q2knl75807f6q3i7y4gqan";
      name = "qtgraphs-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtgrpc-everywhere-src-6.6.0.tar.xz";
      sha256 = "14pdqwv0yw8dgr5nr04aw73fwkljwrg3yhkflfndwnf7mmgvkffs";
      name = "qtgrpc-everywhere-src-6.6.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qthttpserver-everywhere-src-6.6.0.tar.xz";
      sha256 = "0r9wwf239r3q7i633lld2mbmn98d7jqna1fgfxakri68x7bixbpm";
      name = "qthttpserver-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtimageformats-everywhere-src-6.6.0.tar.xz";
      sha256 = "11736il80bdcajz01l836z38g1f0k2am9ilmk203gqkn06sjqm71";
      name = "qtimageformats-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtlanguageserver-everywhere-src-6.6.0.tar.xz";
      sha256 = "03j9kbmv80sj84lbz90692ckg7nd60i6mrbg41lkgxibhqck1jdf";
      name = "qtlanguageserver-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtlocation-everywhere-src-6.6.0.tar.xz";
      sha256 = "1507syiar3dv53km0hl2rf29518arwkk0h2b6fpj5gq8c7kqp5pm";
      name = "qtlocation-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtlottie-everywhere-src-6.6.0.tar.xz";
      sha256 = "0kzq739ziyy8xhzdj57q220sdnjcwnwkgb67gcrsdfd40x8v960x";
      name = "qtlottie-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtmultimedia-everywhere-src-6.6.0.tar.xz";
      sha256 = "10l7sc8c7gwz47z77acvxz5wba14grwqgfpmnx0qh4gcldn26jxs";
      name = "qtmultimedia-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtnetworkauth-everywhere-src-6.6.0.tar.xz";
      sha256 = "0c48rk35qh4q9drs53jijgnhxk8adllnk63wy4rk7sq0disc1m90";
      name = "qtnetworkauth-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtpositioning-everywhere-src-6.6.0.tar.xz";
      sha256 = "0fd51wgxcir8b5n6ljcfhagrkv77w6kimjx7mqzd77km7kx20rcd";
      name = "qtpositioning-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtquick3d-everywhere-src-6.6.0.tar.xz";
      sha256 = "1fkshfd0abnxd5ir8wsf57zms99cg1zhrnn40cmnr7g4jjrkxarp";
      name = "qtquick3d-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtquick3dphysics-everywhere-src-6.6.0.tar.xz";
      sha256 = "00vwzp5qwccjl65dda8s3lyf3dz1pgwhyls15qqgl338dxl5nfbl";
      name = "qtquick3dphysics-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtquickeffectmaker-everywhere-src-6.6.0.tar.xz";
      sha256 = "0zzps7wmjmnbkm37j60xc11jppk4g3nnh7qcn91q68mdqygkgjyp";
      name = "qtquickeffectmaker-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtquicktimeline-everywhere-src-6.6.0.tar.xz";
      sha256 = "145mkgcacjf9ak1ydfkrqfk6371zkjgjd2v264krkv9aaza537h7";
      name = "qtquicktimeline-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtremoteobjects-everywhere-src-6.6.0.tar.xz";
      sha256 = "0szpy60xdmw2spqaczib7mx7k1lnaid8micmy0jh4hmrbgir8496";
      name = "qtremoteobjects-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtscxml-everywhere-src-6.6.0.tar.xz";
      sha256 = "0hqhi9z9cbnpbc9dx22ci3a08javb1hi9cn46h1ks1lbbpdx1v2p";
      name = "qtscxml-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtsensors-everywhere-src-6.6.0.tar.xz";
      sha256 = "1624v0wwpdrcbz4x2jdrzb0r7qfh0qcac3k6pfikn45c9rfvxw18";
      name = "qtsensors-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtserialbus-everywhere-src-6.6.0.tar.xz";
      sha256 = "0k5r57fsdyplbcffq9lnl0bp1smsnqh93kpk3rn5r6gaa9qz1k0q";
      name = "qtserialbus-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtserialport-everywhere-src-6.6.0.tar.xz";
      sha256 = "0ra0v8vc6y2s9y9irh30g1wnyhgd5xlgg6s0k9czyrvsqkqvpz7c";
      name = "qtserialport-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtshadertools-everywhere-src-6.6.0.tar.xz";
      sha256 = "0xcqxwvkga11s150jha0b3iwnp4rvkvbfaxy0a0ln52hqmyk541n";
      name = "qtshadertools-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtspeech-everywhere-src-6.6.0.tar.xz";
      sha256 = "174zpr582nfgj19qk7qdyf4l85q0gwsjx3qfv37z0238hbzxp6wn";
      name = "qtspeech-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtsvg-everywhere-src-6.6.0.tar.xz";
      sha256 = "1pkj7inw76klyld3sy24gcds785lgkjs6zjac9jga0hiypz2bnik";
      name = "qtsvg-everywhere-src-6.6.0.tar.xz";
    };
  };
  qttools = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qttools-everywhere-src-6.6.0.tar.xz";
      sha256 = "16ds0mclns7656hf4phv13pwhigc15z2ghqx7r2nxfrb2jyfx7sf";
      name = "qttools-everywhere-src-6.6.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qttranslations-everywhere-src-6.6.0.tar.xz";
      sha256 = "13072ll3kwb9kvw3a6sjcdific12vf81xbp41zmi1f34dwirmn50";
      name = "qttranslations-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtvirtualkeyboard-everywhere-src-6.6.0.tar.xz";
      sha256 = "0yvpz8mm3g1lj5m3fk95cqw5magfdl4y0y8frsid7gqlym1xp117";
      name = "qtvirtualkeyboard-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtwayland-everywhere-src-6.6.0.tar.xz";
      sha256 = "1s5p0gfkw96nx4k2fp5s3v2rj8c05k8jc2kif0rwhl6hhlnxihrh";
      name = "qtwayland-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtwebchannel-everywhere-src-6.6.0.tar.xz";
      sha256 = "077mlg2zqr002z7z6yqzl3jqc05g5ahz2m06az3zjhsqdn7b7p7x";
      name = "qtwebchannel-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtwebengine-everywhere-src-6.6.0.tar.xz";
      sha256 = "105pag9a2q611ixn5bvc45kpylhrdz5wgw6bk6zssmrcbbq9zp6m";
      name = "qtwebengine-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtwebsockets-everywhere-src-6.6.0.tar.xz";
      sha256 = "03pkgp854pb1rzjixhrbyz4ad174wfikjjisry2c90kf1ifb219f";
      name = "qtwebsockets-everywhere-src-6.6.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.6/6.6.0/submodules/qtwebview-everywhere-src-6.6.0.tar.xz";
      sha256 = "14ikfl38ajgcv3611zjls7liscfyazf49y1plxk0pipsbndqv955";
      name = "qtwebview-everywhere-src-6.6.0.tar.xz";
    };
  };
}
