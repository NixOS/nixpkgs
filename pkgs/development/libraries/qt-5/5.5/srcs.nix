# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
  qt3d = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qt3d-opensource-src-5.5.1.tar.xz";
      sha256 = "1xqvifsy5x2vj7p51c2z1ly7k2yq7l3byhshnkd2bn6b5dp91073";
      name = "qt3d-opensource-src-5.5.1.tar.xz";
    };
  };
  qt5 = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qt5-opensource-src-5.5.1.tar.xz";
      sha256 = "0g83vzsj6hdjmagccy6gxgc1l8q0q6663r9xj58ix4lj7hsphf26";
      name = "qt5-opensource-src-5.5.1.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtactiveqt-opensource-src-5.5.1.tar.xz";
      sha256 = "09dz5jj7gxa9ds2gw6xw8lacmv27ydhi64370q1ncc7khd0p6g3m";
      name = "qtactiveqt-opensource-src-5.5.1.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtandroidextras-opensource-src-5.5.1.tar.xz";
      sha256 = "1cam9zd0kxgyplnaijy91rl8p30j2jbp2ikq9rnigcsglfnx5hd4";
      name = "qtandroidextras-opensource-src-5.5.1.tar.xz";
    };
  };
  qtbase = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtbase-opensource-src-5.5.1.tar.xz";
      sha256 = "05p91m1d9b3gdfm5pgmxw63rk0fdxqz87s77hn9bdip4syjfi96z";
      name = "qtbase-opensource-src-5.5.1.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtcanvas3d-opensource-src-5.5.1.tar.xz";
      sha256 = "105hl3mvsdif416l4dvpxl7r1iw42if8hhrnji8hf4fp6081g6vm";
      name = "qtcanvas3d-opensource-src-5.5.1.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtconnectivity-opensource-src-5.5.1.tar.xz";
      sha256 = "08sh4hzib5l26l6mc6iil4nvl807cn9rn5w46vxw0bsqz3gfcdrn";
      name = "qtconnectivity-opensource-src-5.5.1.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtdeclarative-opensource-src-5.5.1.tar.xz";
      sha256 = "14b7naaa0rk4q6cxf0w62gvamxk812kr65k82zxkdzrzp3plxlaz";
      name = "qtdeclarative-opensource-src-5.5.1.tar.xz";
    };
  };
  qtdoc = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtdoc-opensource-src-5.5.1.tar.xz";
      sha256 = "11hgw1i1qm2yqzfyg0jsvjda9092hjas35l0bmxn6pvnl5asy3cz";
      name = "qtdoc-opensource-src-5.5.1.tar.xz";
    };
  };
  qtenginio = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtenginio-opensource-src-5.5.1.tar.xz";
      sha256 = "1qpg9pcniqp5xxi2qrc6indqdyn850djk0njiniandbabfykd6d7";
      name = "qtenginio-opensource-src-5.5.1.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtgraphicaleffects-opensource-src-5.5.1.tar.xz";
      sha256 = "0irdq4lfbv740mbvd40x62k3zzj0aj8h95gsxg79wa54nf6hzjlv";
      name = "qtgraphicaleffects-opensource-src-5.5.1.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtimageformats-opensource-src-5.5.1.tar.xz";
      sha256 = "19alny9bm2lzzlxicbvw56ra4qcxdrnm9054zs4z1y82qq0fwzy9";
      name = "qtimageformats-opensource-src-5.5.1.tar.xz";
    };
  };
  qtlocation = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtlocation-opensource-src-5.5.1.tar.xz";
      sha256 = "05k31nm1p444fixplspgh1d5j4f3xz6z674jpr8497v4hz5lis8z";
      name = "qtlocation-opensource-src-5.5.1.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtmacextras-opensource-src-5.5.1.tar.xz";
      sha256 = "0n4hxi9xhnyvp5cxklr9ygg4ficvahak2w73kr9ihqckrkym0lq2";
      name = "qtmacextras-opensource-src-5.5.1.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtmultimedia-opensource-src-5.5.1.tar.xz";
      sha256 = "0zwmgmiix56c567qw5xnijd1y43mbjg4jw1n624c31qmyjcwmivw";
      name = "qtmultimedia-opensource-src-5.5.1.tar.xz";
    };
  };
  qtquick1 = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtquick1-opensource-src-5.5.1.tar.xz";
      sha256 = "0b0znnwy2fv5rn368nw7ph2fypz16fchb09id63hm7wbkbjsf4n8";
      name = "qtquick1-opensource-src-5.5.1.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtquickcontrols-opensource-src-5.5.1.tar.xz";
      sha256 = "1w7w87c8i6v3p78psmjb30fh9sx7745m5jyjkdi6q1jnss4q6yhv";
      name = "qtquickcontrols-opensource-src-5.5.1.tar.xz";
    };
  };
  qtscript = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtscript-opensource-src-5.5.1.tar.xz";
      sha256 = "1z98x3758mk24wf0nxxw4lphbxw1xxzl1q27cjqbq8lgk7fxsind";
      name = "qtscript-opensource-src-5.5.1.tar.xz";
    };
  };
  qtsensors = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtsensors-opensource-src-5.5.1.tar.xz";
      sha256 = "1spfr2pn8zz5vz3qz9lzs0wfshmim6hdgf2fpmwpcpcsfb04y9jx";
      name = "qtsensors-opensource-src-5.5.1.tar.xz";
    };
  };
  qtserialport = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtserialport-opensource-src-5.5.1.tar.xz";
      sha256 = "0ylgjscmql3lspzv0cr5n4g1v354frz0yfalvswvkc9x0bxxnd50";
      name = "qtserialport-opensource-src-5.5.1.tar.xz";
    };
  };
  qtsvg = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtsvg-opensource-src-5.5.1.tar.xz";
      sha256 = "1iwibbh835cpxbfh7rnrpvl9k20valr6h256np59rzdy92z8ixgp";
      name = "qtsvg-opensource-src-5.5.1.tar.xz";
    };
  };
  qttools = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qttools-opensource-src-5.5.1.tar.xz";
      sha256 = "1zbvr039sv0jzd41ngarxif6954bl50pha8814b5hw3i977gcqa3";
      name = "qttools-opensource-src-5.5.1.tar.xz";
    };
  };
  qttranslations = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qttranslations-opensource-src-5.5.1.tar.xz";
      sha256 = "1im4qzpyp1wqrrrlwc4r56b46w5y4bxg2m0y7wkcmihb1xqh1y21";
      name = "qttranslations-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwayland = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwayland-opensource-src-5.5.1.tar.xz";
      sha256 = "19nxifpg9q785ahzaii2fd2911cg5m0dpk5v041sylm997f4p063";
      name = "qtwayland-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwebchannel-opensource-src-5.5.1.tar.xz";
      sha256 = "1l0m5xjxg5va9dwvgf52r52inl4dl3954d16rfiwnkndazp9ahkz";
      name = "qtwebchannel-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwebengine-opensource-src-5.5.1.tar.xz";
      sha256 = "141bgr3x7n2vjbsydgll44aq0pcf99gn2l1l1jpim685sf6k4kbw";
      name = "qtwebengine-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwebkit-examples = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwebkit-examples-opensource-src-5.5.1.tar.xz";
      sha256 = "1ij65v3nzh5f6rdq43w6vmljjgfw1vky8dd6s4kr093d5ns3b289";
      name = "qtwebkit-examples-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwebkit = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwebkit-opensource-src-5.5.1.tar.xz";
      sha256 = "0sbdglcf57lmgbcybimvvbpqikn3blb1pxvd71sdhsiypnfkyn3p";
      name = "qtwebkit-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwebsockets-opensource-src-5.5.1.tar.xz";
      sha256 = "1srdn668z62j95q1wwhg6xk2dic407r4wl5yi1qk743vhr586kng";
      name = "qtwebsockets-opensource-src-5.5.1.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtwinextras-opensource-src-5.5.1.tar.xz";
      sha256 = "07w5ipiwvvapasjswk0g4ndcp0lq65pz2n6l348zwfb0gand406b";
      name = "qtwinextras-opensource-src-5.5.1.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtx11extras-opensource-src-5.5.1.tar.xz";
      sha256 = "0rgbxgp5l212c4vg8z685zv008j9s03mx8p576ny2qibjwfs11v3";
      name = "qtx11extras-opensource-src-5.5.1.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.5.1";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.5/5.5.1/submodules/qtxmlpatterns-opensource-src-5.5.1.tar.xz";
      sha256 = "1v78s0jygg83yzyldwms8zb72cwp718cc5ialc2ki3lqa81fndxm";
      name = "qtxmlpatterns-opensource-src-5.5.1.tar.xz";
    };
  };
}
