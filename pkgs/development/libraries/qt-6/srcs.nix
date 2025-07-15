# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qt3d-everywhere-src-6.9.1.tar.xz";
      sha256 = "1127kkbrds6xsd28p47drs51py5x8gsv2rwbllkb6yqlc1x4jilw";
      name = "qt3d-everywhere-src-6.9.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qt5compat-everywhere-src-6.9.1.tar.xz";
      sha256 = "0yli7mbsdhksx57n05axr3kkspf9nm56w6bm1rbl0p0d7yn2diwn";
      name = "qt5compat-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtactiveqt-everywhere-src-6.9.1.tar.xz";
      sha256 = "0lvd6566yycfid6nq66m5cl3aw5bfzfifbhcpnqangvq1vla2zpx";
      name = "qtactiveqt-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtbase-everywhere-src-6.9.1.tar.xz";
      sha256 = "13pjmha1jpalpy5qc5gijny7i648clsmcc08c5cik6nchfzyvjj0";
      name = "qtbase-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtcharts-everywhere-src-6.9.1.tar.xz";
      sha256 = "1ly3mq4hgl4b20grajqy9bw16cx50d4drjxr3ljfj5n8gbmip1xq";
      name = "qtcharts-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtconnectivity-everywhere-src-6.9.1.tar.xz";
      sha256 = "05qabslwr7dc7mfkgkr2ikqlb93c0dkfyg2vbvc5lk8h280yb229";
      name = "qtconnectivity-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtdatavis3d-everywhere-src-6.9.1.tar.xz";
      sha256 = "1irjbdm8ypm01zx18rwq8sp161fq9yjhbx01pcgfdix7y9sqnyac";
      name = "qtdatavis3d-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtdeclarative-everywhere-src-6.9.1.tar.xz";
      sha256 = "15zc9i9d3c9r2bqbcavqn77qk2vwcwlmp5kv73pdg681vxjldffc";
      name = "qtdeclarative-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtdoc-everywhere-src-6.9.1.tar.xz";
      sha256 = "1d8sdnwimvy8fi7cihkxzjllri5gsldy39rzqwyxv4nfwnxbw33f";
      name = "qtdoc-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtgraphs-everywhere-src-6.9.1.tar.xz";
      sha256 = "0i1lb7zdvhxyv51g9h667g7wq50h6x11w88v68x5mfyda98dqbgm";
      name = "qtgraphs-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtgrpc-everywhere-src-6.9.1.tar.xz";
      sha256 = "0l574fwlqszk3zny2mcbka8ipi8bhj8m67jsd7yv129j42g8ck63";
      name = "qtgrpc-everywhere-src-6.9.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qthttpserver-everywhere-src-6.9.1.tar.xz";
      sha256 = "0lrby1ii7ic0m3wnv1hvb5izzwrk5ryqvbi723qnbhxvw88vbixz";
      name = "qthttpserver-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtimageformats-everywhere-src-6.9.1.tar.xz";
      sha256 = "0z2py4x0shdn29l9656r63xc8gzk9bgxlgi3qx9bg6xgv8wg5sgb";
      name = "qtimageformats-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtlanguageserver-everywhere-src-6.9.1.tar.xz";
      sha256 = "1v486kb11mg65bvg88mm306nvq55kg6glnqiwfv9n2vn28v3a5ya";
      name = "qtlanguageserver-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtlocation-everywhere-src-6.9.1.tar.xz";
      sha256 = "0mzg4z0zra13czgygaxim8wn4a2lzndly3w0ymcxwzh4gs8fis60";
      name = "qtlocation-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtlottie-everywhere-src-6.9.1.tar.xz";
      sha256 = "18lbl6pxvfiwl84y92xwnm4cayxs8rdfgmvrq44n3jbk0wp8rs4f";
      name = "qtlottie-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtmultimedia-everywhere-src-6.9.1.tar.xz";
      sha256 = "079r0wp4nwyp4a5cannz3vf99aj4dvydwydvwbw5bvhqjm2kcplm";
      name = "qtmultimedia-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtnetworkauth-everywhere-src-6.9.1.tar.xz";
      sha256 = "1jrrfcw3aa93xaq95xhy0iyigldmvgamy5452mpm8d926xdv3bbz";
      name = "qtnetworkauth-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtpositioning-everywhere-src-6.9.1.tar.xz";
      sha256 = "09pz0sbzcvhcaag7g7pidcnyvrx2kaxsxr73y2iqq949955p6qkh";
      name = "qtpositioning-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtquick3d-everywhere-src-6.9.1.tar.xz";
      sha256 = "0xwr5kdz1yn0arby4jipbh0j8z1x8ppiqhswddyipmdzizd005pn";
      name = "qtquick3d-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtquick3dphysics-everywhere-src-6.9.1.tar.xz";
      sha256 = "0kx2vj6qwwp05iizfnsmbn2337w70crah4zcdm1ah2f4p1g3ds36";
      name = "qtquick3dphysics-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtquickeffectmaker-everywhere-src-6.9.1.tar.xz";
      sha256 = "0caxs6xcm5c7g85xyln5jjvz4b4g6flww7kq9vsl9fs20v21gdir";
      name = "qtquickeffectmaker-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtquicktimeline-everywhere-src-6.9.1.tar.xz";
      sha256 = "153ji60xg55m85zg0px5nq1wbpkn61xf0whkjghf8y41rbkxpgvq";
      name = "qtquicktimeline-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtremoteobjects-everywhere-src-6.9.1.tar.xz";
      sha256 = "040a5s6sx5y0vpxjdmvici63yxr4rn9qisigpbjc4wlggfg0fgr7";
      name = "qtremoteobjects-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtscxml-everywhere-src-6.9.1.tar.xz";
      sha256 = "10274n4gslgh59sagyijllnskp204i16zm7bdpx58fmk4chdwcqc";
      name = "qtscxml-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtsensors-everywhere-src-6.9.1.tar.xz";
      sha256 = "0v4w815698zgxhmk681ygfsjlbp1y4gqdmbb0pz2vm6gr8d16jzh";
      name = "qtsensors-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtserialbus-everywhere-src-6.9.1.tar.xz";
      sha256 = "1mq4mghn19m7m0mkbn6llwiprabr4ym8rpd9ks05spsnhd2ww7j9";
      name = "qtserialbus-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtserialport-everywhere-src-6.9.1.tar.xz";
      sha256 = "047z7vchc01rki445i7qh5mqy3xh0i6ww1l34s4swx0c719fv3w0";
      name = "qtserialport-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtshadertools-everywhere-src-6.9.1.tar.xz";
      sha256 = "0x2b7dpkgdngpbv1g5qc6ffa4lwq4d8g3r3vdi5zp1q8rr6d47jf";
      name = "qtshadertools-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtspeech-everywhere-src-6.9.1.tar.xz";
      sha256 = "0a0lgjxkdfisczkaw7njs87a9qffigygn311chgqzvz2ragza1v8";
      name = "qtspeech-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtsvg-everywhere-src-6.9.1.tar.xz";
      sha256 = "1mdvk8y7dfi8ibv36ccvfbmnsvm2y6dm27l6v6pz47w9zpjmvz1d";
      name = "qtsvg-everywhere-src-6.9.1.tar.xz";
    };
  };
  qttools = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qttools-everywhere-src-6.9.1.tar.xz";
      sha256 = "0k2b7z7g41pkq0bccvmwpalmn2ryhl0ccd4zv4zh9zfcyiiabi4h";
      name = "qttools-everywhere-src-6.9.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qttranslations-everywhere-src-6.9.1.tar.xz";
      sha256 = "0hd707fpsij9bzl143615a4ags6y0nkwdplzlzmwsizlanjs2qcp";
      name = "qttranslations-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtvirtualkeyboard-everywhere-src-6.9.1.tar.xz";
      sha256 = "07r87pg50drrv2z3b6ldlrvz8261xmq6jfcja9wg0dmqplw9l1c0";
      name = "qtvirtualkeyboard-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtwayland-everywhere-src-6.9.1.tar.xz";
      sha256 = "0gifjc4l85ilr1gb0p9dy2s2aypskjp8c7wskfqyp03id07fl8bx";
      name = "qtwayland-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtwebchannel-everywhere-src-6.9.1.tar.xz";
      sha256 = "1h7rzjsim2rxdw25sks4yz8r03llr6q8kcc081n43z0a47ch3d0r";
      name = "qtwebchannel-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtwebengine-everywhere-src-6.9.1.tar.xz";
      sha256 = "0v62j4zzya6yf91630ii6y4m62md69zfs1r21xi6v3rl5gigszbq";
      name = "qtwebengine-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtwebsockets-everywhere-src-6.9.1.tar.xz";
      sha256 = "1xa8yx1v5xk1zn2wc4gssali0k2l0yn6w2ywxsccq0kz7f38rglq";
      name = "qtwebsockets-everywhere-src-6.9.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.9.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.1/submodules/qtwebview-everywhere-src-6.9.1.tar.xz";
      sha256 = "19ar1pmf9q39mqvnjkfrxrblgl1vn65zigj194n098ppp3xx96n2";
      name = "qtwebview-everywhere-src-6.9.1.tar.xz";
    };
  };
}
