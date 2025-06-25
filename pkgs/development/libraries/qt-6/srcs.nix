# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qt3d-everywhere-src-6.9.0.tar.xz";
      sha256 = "1hkcf6j87fpw9ss5vvcaqh3km0vv0f0m3acwvnr3fgc781nxa7aj";
      name = "qt3d-everywhere-src-6.9.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qt5compat-everywhere-src-6.9.0.tar.xz";
      sha256 = "0qq7f4gk09jyjwj9hr5ig0jwagywsqbsymydw3xp2851scwhbgjm";
      name = "qt5compat-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtactiveqt-everywhere-src-6.9.0.tar.xz";
      sha256 = "0gl50kv1dh33jiwsfmgb1fgpkynzzh5z53024l893i0gfkc4nc93";
      name = "qtactiveqt-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtbase-everywhere-src-6.9.0.tar.xz";
      sha256 = "132ry38i7kzapdr23bp39sar76np44is7m059bq1m01mm0p0r061";
      name = "qtbase-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtcharts-everywhere-src-6.9.0.tar.xz";
      sha256 = "0a3z65fd54gm4w50si1makq972lj7g3yi1ys188ppr2zya3r474a";
      name = "qtcharts-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtconnectivity-everywhere-src-6.9.0.tar.xz";
      sha256 = "16452vxd4by1snl42bbg8vk5qr71i88ngspwi8qgkfdjmj6jyh7z";
      name = "qtconnectivity-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtdatavis3d-everywhere-src-6.9.0.tar.xz";
      sha256 = "05c0kmzwiw7kgpzkh470x1zggwn7rba7qg7fza6jm4wcsl9vf31i";
      name = "qtdatavis3d-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtdeclarative-everywhere-src-6.9.0.tar.xz";
      sha256 = "0g8dl9dnzlj4nm08pjdcr6fvnyvzxazy52gr6iki6yl422jmy5x3";
      name = "qtdeclarative-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtdoc-everywhere-src-6.9.0.tar.xz";
      sha256 = "1zdr5vi313rph1hz1c5a1wyrrspifjm5xaz475xc3yic7imn6fqz";
      name = "qtdoc-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtgraphs-everywhere-src-6.9.0.tar.xz";
      sha256 = "1im0z8m50yy3p8v6rkxc7agyx061c644asjqnljjajwkq76hhnwy";
      name = "qtgraphs-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtgrpc-everywhere-src-6.9.0.tar.xz";
      sha256 = "0dxichzs2371xqzyrqgf74z18phykv23xagwz6ldkh0s31vf0mrr";
      name = "qtgrpc-everywhere-src-6.9.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qthttpserver-everywhere-src-6.9.0.tar.xz";
      sha256 = "0wxf29hyai0v9p7sx0r6a7lz00ps18x6mcls3330jk2c3gpwzlli";
      name = "qthttpserver-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtimageformats-everywhere-src-6.9.0.tar.xz";
      sha256 = "0vv082jfird2m7x60iz8kb6kghaj2zwsk7q7837rggsp58jccir0";
      name = "qtimageformats-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtlanguageserver-everywhere-src-6.9.0.tar.xz";
      sha256 = "0bj9azip0sxmcj4girdscvgbn32givxi6w0jcdmy7vjjc41mxrpf";
      name = "qtlanguageserver-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtlocation-everywhere-src-6.9.0.tar.xz";
      sha256 = "1537haryrrvcdj0j85wid4w4a100ngdrh4f2q2p2saxaq725m8md";
      name = "qtlocation-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtlottie-everywhere-src-6.9.0.tar.xz";
      sha256 = "1gps985lzrzxgarhi5ykzmc88walr25b1c9nc0k7k8l7lla1dfnl";
      name = "qtlottie-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtmultimedia-everywhere-src-6.9.0.tar.xz";
      sha256 = "1351rayivxzjpfflag2jaym987b6yx19cqw0ja9f3qrx9wcknp4r";
      name = "qtmultimedia-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtnetworkauth-everywhere-src-6.9.0.tar.xz";
      sha256 = "065lzvvm9i064msk90qy5919m983n4q67k17s78n8jbx4as0iizs";
      name = "qtnetworkauth-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtpositioning-everywhere-src-6.9.0.tar.xz";
      sha256 = "1layc0j3d0r75yyvgp5irmvbjih1z1csn2lic9arry9bv40lq2y0";
      name = "qtpositioning-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtquick3d-everywhere-src-6.9.0.tar.xz";
      sha256 = "1274k4rsriyshm8mq55mk9kij2vjsaja1cabpfvambm5vj7jd5d2";
      name = "qtquick3d-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtquick3dphysics-everywhere-src-6.9.0.tar.xz";
      sha256 = "1816b3sxs99lrq3krjsjdr9vi9q7ayhrgqz6sz819bqzb5z2y7jz";
      name = "qtquick3dphysics-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtquickeffectmaker-everywhere-src-6.9.0.tar.xz";
      sha256 = "1akia03g1ickp27bdqqr8r7sy7yq740wyvb895csdq9qrbj16qli";
      name = "qtquickeffectmaker-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtquicktimeline-everywhere-src-6.9.0.tar.xz";
      sha256 = "0j76cb4db9kpcr5ascgljz3jy8jyhvnrjisk2ni1a5kk1gfjr7rk";
      name = "qtquicktimeline-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtremoteobjects-everywhere-src-6.9.0.tar.xz";
      sha256 = "1pbhjwiygydafqd5hlcgda39dxppcmxzhn1zn0va9zbqzps14fpl";
      name = "qtremoteobjects-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtscxml-everywhere-src-6.9.0.tar.xz";
      sha256 = "14k8kak4670z58wg72jx75g3cwbvf2fp897ag5npfk8j3hjbafx7";
      name = "qtscxml-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtsensors-everywhere-src-6.9.0.tar.xz";
      sha256 = "0rz4d2rq65rdls6q976k6p5b064307kkvy52jw1x0s57yk0kfqd4";
      name = "qtsensors-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtserialbus-everywhere-src-6.9.0.tar.xz";
      sha256 = "0gsrhm2s039ym6hr5sql7xsm46xmripxb8np4wn6w9gj24s0jihd";
      name = "qtserialbus-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtserialport-everywhere-src-6.9.0.tar.xz";
      sha256 = "0m5rhr07mq2ifysymskhnql4dw8cnll4jq2ipzxmhgkbrbsn5rzv";
      name = "qtserialport-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtshadertools-everywhere-src-6.9.0.tar.xz";
      sha256 = "1fzlsr19c9indwmr56lbhd2f7vmxnlzsfv1z2qxy5pn338l40v4i";
      name = "qtshadertools-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtspeech-everywhere-src-6.9.0.tar.xz";
      sha256 = "0wf971cqr6zvb6l2dax10l7kjl9qil8ssds4rsipfgblf66bd0d9";
      name = "qtspeech-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtsvg-everywhere-src-6.9.0.tar.xz";
      sha256 = "1z0mj8avfab6wzha337cd1cjf3ax5w6112zmiaj5x4wm1j9rsdgc";
      name = "qtsvg-everywhere-src-6.9.0.tar.xz";
    };
  };
  qttools = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qttools-everywhere-src-6.9.0.tar.xz";
      sha256 = "196955jjwrpjv43qdv6qx9yjfi1ajwjni4hs80i914rzrj4mar7s";
      name = "qttools-everywhere-src-6.9.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qttranslations-everywhere-src-6.9.0.tar.xz";
      sha256 = "0gwccq2gd07iz1z9gpzwxfxr6fb8hdwh20r4dxavriy7bzpq2m8x";
      name = "qttranslations-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtvirtualkeyboard-everywhere-src-6.9.0.tar.xz";
      sha256 = "09wisql4nsvz01rzrjlri9k4a83q2mi2ckx7lqpc836mppzqjm5q";
      name = "qtvirtualkeyboard-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtwayland-everywhere-src-6.9.0.tar.xz";
      sha256 = "018qr4q32w0c99vnyh433q4nym1ybv24jshf2fyh7dadn3y1cd2h";
      name = "qtwayland-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtwebchannel-everywhere-src-6.9.0.tar.xz";
      sha256 = "1vmzzb823apg67mr9za85i5jw86ipk38091kbyapsyp1vnf9ll8h";
      name = "qtwebchannel-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtwebengine-everywhere-src-6.9.0.tar.xz";
      sha256 = "17kqi6vh1gz3qkq9i6ywzx3bfnhhja7l8a5jkmr5ivc5bv4d2crb";
      name = "qtwebengine-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtwebsockets-everywhere-src-6.9.0.tar.xz";
      sha256 = "0h29a77599653npki41hcgpmyya2mjfrvrnm92sf197kmiydsfkb";
      name = "qtwebsockets-everywhere-src-6.9.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.9.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.9/6.9.0/submodules/qtwebview-everywhere-src-6.9.0.tar.xz";
      sha256 = "0szdsx10vhj1ivhnqviq8qv1ji1mzhzpz22svz2c64pbih70f92v";
      name = "qtwebview-everywhere-src-6.9.0.tar.xz";
    };
  };
}
