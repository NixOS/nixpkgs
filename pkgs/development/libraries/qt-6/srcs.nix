# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qt3d-everywhere-src-6.8.1.tar.xz";
      sha256 = "0dj2gh6lrcy096g0f9cyawg16c7n46lqqn3bgicr5bbv3f3hdc08";
      name = "qt3d-everywhere-src-6.8.1.tar.xz";
    };
  };
  qt5compat = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qt5compat-everywhere-src-6.8.1.tar.xz";
      sha256 = "1z34289x0j40f3jylwz62aqqq21aqkvpz2wwibx330ydnj4c1j05";
      name = "qt5compat-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtactiveqt-everywhere-src-6.8.1.tar.xz";
      sha256 = "1mwc5incb7hy33d0jskxl3yliw6jvgky8qxq9cgmplx5p7m48scj";
      name = "qtactiveqt-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtbase = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtbase-everywhere-src-6.8.1.tar.xz";
      sha256 = "1bywb2nxdqdwnc68qvpaz0sq58lgw0mfl6041sy7kmrvxxi4bca0";
      name = "qtbase-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtcharts = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtcharts-everywhere-src-6.8.1.tar.xz";
      sha256 = "0abxy1b42rzvg1yksbmzvdpapxdp8n37jclkv44gb3i4dvqs7pif";
      name = "qtcharts-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtconnectivity-everywhere-src-6.8.1.tar.xz";
      sha256 = "0724lq45jjw223n681rnrsjxh97jn5gi8ki7i03p3412mpkldzfc";
      name = "qtconnectivity-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtdatavis3d-everywhere-src-6.8.1.tar.xz";
      sha256 = "03jba3d5arysrw1drz4a5kj2kjrb6lrwfrrhvgg3mamqdph8zrns";
      name = "qtdatavis3d-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtdeclarative-everywhere-src-6.8.1.tar.xz";
      sha256 = "1z1rq2j4cwhz5wgibdb8a6xw339vs6d231b4vyqyvp3a3df5vlcm";
      name = "qtdeclarative-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtdoc = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtdoc-everywhere-src-6.8.1.tar.xz";
      sha256 = "1ckvrpn32v20vd0m06s46vxcrhn8plq738bzahz9329rvdild9vh";
      name = "qtdoc-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtgraphs-everywhere-src-6.8.1.tar.xz";
      sha256 = "102asm1c2pmn3xb784l74qgafkl2yp5gh3ml59jkas4kd7gf6ihy";
      name = "qtgraphs-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtgrpc-everywhere-src-6.8.1.tar.xz";
      sha256 = "102y1gs7r9097cvym8zds03cj8ffs8hc8mza5bsfa4mhjrq5qqdi";
      name = "qtgrpc-everywhere-src-6.8.1.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qthttpserver-everywhere-src-6.8.1.tar.xz";
      sha256 = "09qbkg1lx0rdq6bjvlw5n61q8hawg1b4cd0y9p3v2nf3vl7vk32x";
      name = "qthttpserver-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtimageformats-everywhere-src-6.8.1.tar.xz";
      sha256 = "0dyj7n8dh8fawaxgxd537ifn4ppb6qwyndiy53vmz3x9ka8c530k";
      name = "qtimageformats-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtlanguageserver-everywhere-src-6.8.1.tar.xz";
      sha256 = "0zkdiqy26fji2mqh827m7xap5gv0xrn5nqihibim6aj3q4v98pl6";
      name = "qtlanguageserver-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtlocation = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtlocation-everywhere-src-6.8.1.tar.xz";
      sha256 = "1vsr9fpdsslz78fh6vb3qrqjgqip5s9amls99qfkm1xvp1gdnw4h";
      name = "qtlocation-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtlottie = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtlottie-everywhere-src-6.8.1.tar.xz";
      sha256 = "0jhpf3hmhzr0ns4qd0zsdblxadmparmcj6n24js95pxzzk2l8hw2";
      name = "qtlottie-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtmultimedia-everywhere-src-6.8.1.tar.xz";
      sha256 = "0lzrfg8vscjc3n79rlb0jm8pkb4r8xsa8m9clvqbgyls9w9qgykm";
      name = "qtmultimedia-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtnetworkauth-everywhere-src-6.8.1.tar.xz";
      sha256 = "0920qx3zw0567la4wl1fx3z4qrs3pmlvsf14hbgvnpwwjax691hi";
      name = "qtnetworkauth-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtpositioning-everywhere-src-6.8.1.tar.xz";
      sha256 = "13gpglkgacmpjikga5wsbvghnhvp7vzzizsvg2qvxm4i4liyf473";
      name = "qtpositioning-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtquick3d-everywhere-src-6.8.1.tar.xz";
      sha256 = "1rqcy8ds8kidccp193paklims7l1676kfskync5d9z4mdig38g9z";
      name = "qtquick3d-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtquick3dphysics-everywhere-src-6.8.1.tar.xz";
      sha256 = "0vhabyblidy7wf80jl27bq25rpq5f9pys8dj9bxj40rgazdqwbk5";
      name = "qtquick3dphysics-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtquickeffectmaker-everywhere-src-6.8.1.tar.xz";
      sha256 = "1xjizd15q2pgvaikw5vjkf2chvkdrfy3c66cfar91gba6l9xykrd";
      name = "qtquickeffectmaker-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtquicktimeline-everywhere-src-6.8.1.tar.xz";
      sha256 = "18qjzvnhx24lhfp9fv53wq3jd4w1dqrzlg7v044cwyzx4y71kg7x";
      name = "qtquicktimeline-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtremoteobjects-everywhere-src-6.8.1.tar.xz";
      sha256 = "1y2riwh227s1krp4l96s8fy4lagmrqmc2ynxrz8p2jv10l7qgwky";
      name = "qtremoteobjects-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtscxml = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtscxml-everywhere-src-6.8.1.tar.xz";
      sha256 = "1mjgc49gr7fsgqm1m8h5xij7m7frs6ji5026j3dyvmmcrx26yh1g";
      name = "qtscxml-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtsensors = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtsensors-everywhere-src-6.8.1.tar.xz";
      sha256 = "0l4p3lh5g8w2dymy7k661b4qz7kmpvv0xrw0gdj0rm2h91hrpx21";
      name = "qtsensors-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtserialbus-everywhere-src-6.8.1.tar.xz";
      sha256 = "1nhmxm44achdagfqvzd39yjriqr1kpm9x7wfh6by4fjwxj98sy20";
      name = "qtserialbus-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtserialport = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtserialport-everywhere-src-6.8.1.tar.xz";
      sha256 = "15c3jdncjvc172sqk7nbm4z8wc6pfbnv18gfwc1v0zbdq2jp53h9";
      name = "qtserialport-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtshadertools-everywhere-src-6.8.1.tar.xz";
      sha256 = "0ij8khb8k9qzmvkn1g2ks90m175syw897a2bqx1q0fj76bb0rdsm";
      name = "qtshadertools-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtspeech = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtspeech-everywhere-src-6.8.1.tar.xz";
      sha256 = "1pxcw468f003qx645xv377rm55jkbqrddl49xg6b1c2pq4vgxidh";
      name = "qtspeech-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtsvg = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtsvg-everywhere-src-6.8.1.tar.xz";
      sha256 = "1l0darn7apr142kzn4k9hm91f2dv4r27rms8gjm2ssz3jqsyf39x";
      name = "qtsvg-everywhere-src-6.8.1.tar.xz";
    };
  };
  qttools = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qttools-everywhere-src-6.8.1.tar.xz";
      sha256 = "0ba37hl5pp3zpf3n9vqsq4zrm75n2i8wdaam04d6if08pq4x8hwx";
      name = "qttools-everywhere-src-6.8.1.tar.xz";
    };
  };
  qttranslations = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qttranslations-everywhere-src-6.8.1.tar.xz";
      sha256 = "0jjs0c1j62rlp4sv3b6lhr3xvsjw91vi1rbxh0xj8llix69n0nk3";
      name = "qttranslations-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtvirtualkeyboard-everywhere-src-6.8.1.tar.xz";
      sha256 = "0r52i57lfzy6yvjg9zhdppn1x8vhia61andnhlp77v4k82ya68hh";
      name = "qtvirtualkeyboard-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtwayland = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtwayland-everywhere-src-6.8.1.tar.xz";
      sha256 = "00x2xhlp3iyxvxkk9rl9wxa6lw7x727rq8sbpzw15p9d9vggn9i2";
      name = "qtwayland-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtwebchannel-everywhere-src-6.8.1.tar.xz";
      sha256 = "0fknlmlaajrf7cmkk4wnswmr51zam0zh4id19n99wc18j5zry4vb";
      name = "qtwebchannel-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtwebengine-everywhere-src-6.8.1.tar.xz";
      sha256 = "1g4imqhd3rnkq5sjjiapczlj5pl3p4yvcj8fhg751kzdr0xf1a0v";
      name = "qtwebengine-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtwebsockets-everywhere-src-6.8.1.tar.xz";
      sha256 = "0gqy6kgixyvpwayldjwd072i3k48pz4sca84n31d3v8bfvldmkz4";
      name = "qtwebsockets-everywhere-src-6.8.1.tar.xz";
    };
  };
  qtwebview = {
    version = "6.8.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.8/6.8.1/submodules/qtwebview-everywhere-src-6.8.1.tar.xz";
      sha256 = "08lyas1zvc2yj8h7d75yf9n6jmjm0qvvlwaqjprhdyl4kjgc0szm";
      name = "qtwebview-everywhere-src-6.8.1.tar.xz";
    };
  };
}
