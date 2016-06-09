# DO NOT EDIT! This file is generated automatically by manifest.sh
{ fetchurl, mirror }:

{
  qttools = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qttools-opensource-src-5.6.0.tar.xz";
      sha256 = "1791c9a1vxv0q2ywr00ya5rxaggidsq81s8h8fwmql75pdhlq90d";
      name = "qttools-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwebengine-opensource-src-5.6.0.tar.xz";
      sha256 = "00vaqx3mypqlnjkfwhx54r6ygfs07amkwc4rma0sg64zdjnvb8la";
      name = "qtwebengine-opensource-src-5.6.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtserialbus-opensource-src-5.6.0.tar.xz";
      sha256 = "13hbmj9pilh5gkbbngfbp225qvc650pnzvpzawpnf69zwl757jlc";
      name = "qtserialbus-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwayland = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwayland-opensource-src-5.6.0.tar.xz";
      sha256 = "1k5zsgz54wlkxm3ici55lbbz286bk2791vri02bjgja5y9102pdm";
      name = "qtwayland-opensource-src-5.6.0.tar.xz";
    };
  };
  qt5 = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qt5-opensource-src-5.6.0.tar.xz";
      sha256 = "195dl9pk9slbiy6mgwwpc70vaw62sdhxc3lxmlnyddk99widqa3k";
      name = "qt5-opensource-src-5.6.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtimageformats-opensource-src-5.6.0.tar.xz";
      sha256 = "1nmsh682idxl0642q7376r9qfxkx0736q9pl4jx179c9lrsl519c";
      name = "qtimageformats-opensource-src-5.6.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtactiveqt-opensource-src-5.6.0.tar.xz";
      sha256 = "0xrjr9jwkxxcv46a8vj77px3v1p36nm6rpvyxma0wb4xhpippp3a";
      name = "qtactiveqt-opensource-src-5.6.0.tar.xz";
    };
  };
  qtdoc = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtdoc-opensource-src-5.6.0.tar.xz";
      sha256 = "1z69yl8nkvp21arjhzl34gr8gvxm5b03d58lwnddl4mkaxbi4vap";
      name = "qtdoc-opensource-src-5.6.0.tar.xz";
    };
  };
  qtsensors = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtsensors-opensource-src-5.6.0.tar.xz";
      sha256 = "0blwqmkh0hn1716d5fvy0vnh56y9iikl34ayz6ksl0ayxhpkk3si";
      name = "qtsensors-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwebchannel-opensource-src-5.6.0.tar.xz";
      sha256 = "0ky1njksczyfb7y7p5kfgzbx9vgajzy51g2y3vrpfvl6bs9j8m62";
      name = "qtwebchannel-opensource-src-5.6.0.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtmacextras-opensource-src-5.6.0.tar.xz";
      sha256 = "1jkmwppapvymdr1kwdrbjlxhcafcn4jb23ssnhrvvgcq3lnl5lhj";
      name = "qtmacextras-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwebsockets-opensource-src-5.6.0.tar.xz";
      sha256 = "17vi3n27gx3f3c2lii3b70pzz6mpblam3236v6mj439xzrlvi2i6";
      name = "qtwebsockets-opensource-src-5.6.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtconnectivity-opensource-src-5.6.0.tar.xz";
      sha256 = "1ss0ibabiv7n5hakkxmkc4msrwgqcvfffdjajnv5jrq0030v0p0c";
      name = "qtconnectivity-opensource-src-5.6.0.tar.xz";
    };
  };
  qtscript = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtscript-opensource-src-5.6.0.tar.xz";
      sha256 = "0hjhkh4lia1i0iir1i8dr57gizi74h73j0phhir3q3wsglcpax5c";
      name = "qtscript-opensource-src-5.6.0.tar.xz";
    };
  };
  qttranslations = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qttranslations-opensource-src-5.6.0.tar.xz";
      sha256 = "0jfdfj2z0nvf1xblmdxaphn0psjycrb5g3jxxcddkci214gka2cq";
      name = "qttranslations-opensource-src-5.6.0.tar.xz";
    };
  };
  qtlocation = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtlocation-opensource-src-5.6.0.tar.xz";
      sha256 = "1jakjrwic01b5vyij6hfzdfpipandpkj9li3d7wf9bzws0cia3in";
      name = "qtlocation-opensource-src-5.6.0.tar.xz";
    };
  };
  qtserialport = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtserialport-opensource-src-5.6.0.tar.xz";
      sha256 = "07rwhmh9y7b3ycvx4d4d1j32nahf8nhsb9qj99kxz5xrdfv7zvhn";
      name = "qtserialport-opensource-src-5.6.0.tar.xz";
    };
  };
  qtsvg = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtsvg-opensource-src-5.6.0.tar.xz";
      sha256 = "07v4bzxd31dhkhp52y4g2ii0sslmk48cqkkz32v41frqj4qrk1vr";
      name = "qtsvg-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwebview = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwebview-opensource-src-5.6.0.tar.xz";
      sha256 = "0mqbh125bq37xybwslhri4pl861r26cnraiz9ivh4881kqzab3x4";
      name = "qtwebview-opensource-src-5.6.0.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtcanvas3d-opensource-src-5.6.0.tar.xz";
      sha256 = "1kwykm1ffgpjgb3ggd4h2d2x3yhp9jsc0gnwlks620bahagdbbb6";
      name = "qtcanvas3d-opensource-src-5.6.0.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtwinextras-opensource-src-5.6.0.tar.xz";
      sha256 = "14xvm081wjyild2wi7pcilqxdkhc8b0lf9yn7yf7zp576i9ir5aq";
      name = "qtwinextras-opensource-src-5.6.0.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtgraphicaleffects-opensource-src-5.6.0.tar.xz";
      sha256 = "1s0n8hrmrfs53cmm7i45p8zavvmsl0aisd5sgj93p8c5rzyi3s81";
      name = "qtgraphicaleffects-opensource-src-5.6.0.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtxmlpatterns-opensource-src-5.6.0.tar.xz";
      sha256 = "1m0rr0m9zg2d6rdban2p5qyx8rdnjnjsfk3bm72bh47hscxipvds";
      name = "qtxmlpatterns-opensource-src-5.6.0.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtquickcontrols2-opensource-src-5.6.0.tar.xz";
      sha256 = "1q7yp7l32jd3p28587ldxzkj58z1aad9gcs80w6vqc9952i6xv2r";
      name = "qtquickcontrols2-opensource-src-5.6.0.tar.xz";
    };
  };
  qtbase = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtbase-opensource-src-5.6.0.tar.xz";
      sha256 = "0ynnvcs5idivzldsq5ciqg9myg82b3l3906l4vjv54lyamf8mykf";
      name = "qtbase-opensource-src-5.6.0.tar.xz";
    };
  };
  qt3d = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qt3d-opensource-src-5.6.0.tar.xz";
      sha256 = "17a37xhav5mxspx2c9wsgvcilv7ys40q6minmlqd1gnfmsfphqdr";
      name = "qt3d-opensource-src-5.6.0.tar.xz";
    };
  };
  qtenginio = {
    version = "1.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtenginio-opensource-src-1.6.0.tar.xz";
      sha256 = "033z2jncci64s7s9ml5rsfsnrkdmhx1g5dfvr61imv63pzxxqzb2";
      name = "qtenginio-opensource-src-1.6.0.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtx11extras-opensource-src-5.6.0.tar.xz";
      sha256 = "099lc7kxcxgp5s01ddnd6n955fc8866caark43xfs2dw0a6pdva7";
      name = "qtx11extras-opensource-src-5.6.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtdeclarative-opensource-src-5.6.0.tar.xz";
      sha256 = "0k70zlyx1nh35caiav4s3jvg5l029pvilm6sarxmfj73y19z0mcc";
      name = "qtdeclarative-opensource-src-5.6.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtmultimedia-opensource-src-5.6.0.tar.xz";
      sha256 = "11h66xcr3y3w8hhvx801r66yirvf1kppasjlhm25qvr6rpb9jgqh";
      name = "qtmultimedia-opensource-src-5.6.0.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtquickcontrols-opensource-src-5.6.0.tar.xz";
      sha256 = "12vqkxpz5y2bbh083lpsxcianykl8x7am49pmc4x221a5xwrc27c";
      name = "qtquickcontrols-opensource-src-5.6.0.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.6.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.6/5.6.0/submodules/qtandroidextras-opensource-src-5.6.0.tar.xz";
      sha256 = "1qhrn8vhfn0z73bc2ls1b4zfvr7r5gn7b5xdmjp26hi338j55vp0";
      name = "qtandroidextras-opensource-src-5.6.0.tar.xz";
    };
  };
}
