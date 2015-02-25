# This file is generated automatically. DO NOT EDIT!
{ stdenv, fetchurl, mirror }:
[
  {
    name = stdenv.lib.nameFromURL "qtwebengine-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/108ywq0s80nanyrjs95nmfxvxmp1ijv2-qtwebengine-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwebengine-opensource-src-5.4.0.tar.xz";
      sha256 = "0fqmwhl2pxs0w33lqhcwgwdyrj61b8jmd3hc668xwirzsv0ab4db";
      name = "qtwebengine-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-examples-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/dgy0bd4382cak76d34ins8v1rxvcg2zg-qtwebkit-examples-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwebkit-examples-opensource-src-5.4.0.tar.xz";
      sha256 = "1xp9y3q0p5w3gj372hwbzb606akf6ynic94ppwzyhrhy70yjyamh";
      name = "qtwebkit-examples-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsensors-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/3ddk1slwp3sl11q3vrh14vczz1g3k77c-qtsensors-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtsensors-opensource-src-5.4.0.tar.xz";
      sha256 = "0ng1mbvv2ffhk7rs3djiz2i7j297flnn1jkgqk6zpfbjyp6363wa";
      name = "qtsensors-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtandroidextras-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/h77c86qj0fxr233x0b4n669mfd1kd14k-qtandroidextras-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtandroidextras-opensource-src-5.4.0.tar.xz";
      sha256 = "0j40409x68bj6hbfrz0vqzafkbplzfcnlb7b7m72ddav0jm4ad3w";
      name = "qtandroidextras-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtxmlpatterns-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/l30dh38cmmhz1laiwawfyx88d2njnf7s-qtxmlpatterns-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtxmlpatterns-opensource-src-5.4.0.tar.xz";
      sha256 = "09albq9qj82hzphb3y4ivkkly6gjyxmcbghd7m73i9f7kdxnj73r";
      name = "qtxmlpatterns-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtactiveqt-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/02axrl74rym70hs4ncwbpx520a6y5lfk-qtactiveqt-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtactiveqt-opensource-src-5.4.0.tar.xz";
      sha256 = "1kvn8dqyr3iw5w55yba9ljldgc15zsa1ibdkhfwj3rk3579mfxba";
      name = "qtactiveqt-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtx11extras-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/xqd394dy8j57iwvixy09a8mlklllf817-qtx11extras-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtx11extras-opensource-src-5.4.0.tar.xz";
      sha256 = "0k27q46khwf3hzygb145akns37s8cmwbqyzjff810xxqwb4npim3";
      name = "qtx11extras-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttranslations-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/hafxaps23gqkpaq1ryh142jc9fh71kxp-qttranslations-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qttranslations-opensource-src-5.4.0.tar.xz";
      sha256 = "12zrldi5jw6zknwg6p573gvz0f4v22wvwwc5mykj26j8g28qv9xc";
      name = "qttranslations-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwayland-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/ffs7rhirwgyqijcwkv2rn9i0f3126qwp-qtwayland-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwayland-opensource-src-5.4.0.tar.xz";
      sha256 = "0abgsf67whdppg9q35b359wllz2pfzx6vw2gld6hhnhlx7rgf7k0";
      name = "qtwayland-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmultimedia-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/7ap1klckqnjx03i1024jd1nfw1kbdib3-qtmultimedia-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtmultimedia-opensource-src-5.4.0.tar.xz";
      sha256 = "0ldgz677apqj8jm6b7cmma18jv97va26hjqjs3r26hg6gaidpfas";
      name = "qtmultimedia-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmacextras-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/w526ln2xj4bfqw2xbarhidain51idf3k-qtmacextras-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtmacextras-opensource-src-5.4.0.tar.xz";
      sha256 = "0vq4dhsxwi1csy5qnbbjp3fmgmhqb7ah0nzrsickvv37vyfv85hn";
      name = "qtmacextras-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtimageformats-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/yp6paa7psi4fwaih9mcvfxj9vldlmk5k-qtimageformats-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtimageformats-opensource-src-5.4.0.tar.xz";
      sha256 = "0ip0iyn8fz96w5xi8w6dlxx0lhv1glmkdy5myz7zhi0yyy6ng6y8";
      name = "qtimageformats-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttools-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/1x2lvbyc2h25zmjyvawrfzn5yya13fjl-qttools-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qttools-opensource-src-5.4.0.tar.xz";
      sha256 = "06klc0vdqfnj8dwqq64602x0wl8ackcim1y33mw6616kzyba11as";
      name = "qttools-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtconnectivity-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/33mxdwaih2ysjzyvjgfgq86ys9bd9s8x-qtconnectivity-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtconnectivity-opensource-src-5.4.0.tar.xz";
      sha256 = "0f0hkgqr606q4jj8g70xq72lp9q6kdyfw6rdiin8zhnarjxqark3";
      name = "qtconnectivity-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebchannel-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/bx82yn9n0srdzlid1blwg196jqyhhgpp-qtwebchannel-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwebchannel-opensource-src-5.4.0.tar.xz";
      sha256 = "0k2r0qrqrxhw2mjyd9f8r36f04yxfkgw1dmbbdczhw4234jh3sr4";
      name = "qtwebchannel-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtserialport-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/3q6b9l2cwszm9jz5csx2jsfqk08nz9nh-qtserialport-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtserialport-opensource-src-5.4.0.tar.xz";
      sha256 = "1hsqs1dy8x5v3l4z8zk9rjprz14w8nv13j4yy47r4nsgf7pikihg";
      name = "qtserialport-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdoc-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/bbqvydxnaw4asp2a9j4pq0d5zi1zaqsf-qtdoc-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtdoc-opensource-src-5.4.0.tar.xz";
      sha256 = "06gx7b3xq3jdprmwfzsy2c1x7klry1wsrfs1iyjgfq9sdja9d1nm";
      name = "qtdoc-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwinextras-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/by4v18v2k0xaz9znh18qfr8fvy8n67qg-qtwinextras-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwinextras-opensource-src-5.4.0.tar.xz";
      sha256 = "01p3haicfbsg0nb654s16pxl9hr57dksk2w5h2ijghpivqhlzbh3";
      name = "qtwinextras-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtbase-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/01rpn59v04bx5f9mw92v6zq2hl4bigcr-qtbase-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtbase-opensource-src-5.4.0.tar.xz";
      sha256 = "1lciiq64qzbgg8kvc2fl98ykpn7fcjv2q6n2ivbw4yz7ll5j9sns";
      name = "qtbase-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdeclarative-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/mc0dz5hbaqf3sannvg4j7zxwqcsj3g0f-qtdeclarative-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtdeclarative-opensource-src-5.4.0.tar.xz";
      sha256 = "1dnpz86asklm3qvm1wyjm3w1kyr319yas8w03ry9m1pnn1sr4z76";
      name = "qtdeclarative-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtgraphicaleffects-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/r7hpzw01dxh31px5lm1jv6pz753sawrd-qtgraphicaleffects-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtgraphicaleffects-opensource-src-5.4.0.tar.xz";
      sha256 = "06cblcjd6c7nbq1lc8b7mydambf16qmpargc1x0bh3hq6bji0gx4";
      name = "qtgraphicaleffects-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquick1-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/f449vw01acb5jjf74fhfjrjhp8z00dby-qtquick1-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtquick1-opensource-src-5.4.0.tar.xz";
      sha256 = "1p1js3ck3310kbgvnzsfd0gfd4p9c3fccfas7hzkhcj83iybga6m";
      name = "qtquick1-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qt5-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/6nh8apj4l1xpqcjq1lkb9g1n50wd6xsz-qt5-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qt5-opensource-src-5.4.0.tar.xz";
      sha256 = "0gw782dvmvz6c8lpgvn7fi0d8wydjrrfarhjrbbwmswa37492s5r";
      name = "qt5-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtscript-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/zc0k3d4s867p17bas7clvabdsh2xblhh-qtscript-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtscript-opensource-src-5.4.0.tar.xz";
      sha256 = "1l0f6g1m5p9zgc4pbx6xm5b31ygcl4dayj43hwblpwinxh15gwzm";
      name = "qtscript-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebsockets-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/camx69vrzl5ciwmc7rygax1iphcdk474-qtwebsockets-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwebsockets-opensource-src-5.4.0.tar.xz";
      sha256 = "1pybyksa8gwm98f65l3pa8dxbplz882r13b7i0idsg4q9952gk9a";
      name = "qtwebsockets-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquickcontrols-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/y0n7c5safk5174b14a9p6kqw2p2n3vrs-qtquickcontrols-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtquickcontrols-opensource-src-5.4.0.tar.xz";
      sha256 = "07p6z9c1cgyx9qx81mpgnh8dim4q9im714lzk8zyghwi68rl77xm";
      name = "qtquickcontrols-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtenginio-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/afpm16dyv3bis6xfr4lnhnd0xrflpi86-qtenginio-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtenginio-opensource-src-5.4.0.tar.xz";
      sha256 = "0k4j5nc33ijifjpii074bar105z1mn98qg1vzn8q5lq0y7jm82gs";
      name = "qtenginio-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/v0l3znjnhnnlbvbdb33ns3npz1p7dlzw-qtwebkit-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtwebkit-opensource-src-5.4.0.tar.xz";
      sha256 = "1hc8s6l70ikf7ld2x84p6d2wwyxdfqw2pdqlma42wpaxfq3j4rvc";
      name = "qtwebkit-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtlocation-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/kbgbnl01j85iab7a88x4gi3q2n40n9zr-qtlocation-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtlocation-opensource-src-5.4.0.tar.xz";
      sha256 = "0mnlh6z8hq9j32sxqsd8al811p4iv99wd8bsm97w9nyxbwdhqhp8";
      name = "qtlocation-opensource-src-5.4.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsvg-opensource-src-5.4.0.tar.xz" ".tar";
    store = "/nix/store/h9qfbbj46sc2nhx24354b9cgq9hnssdc-qtsvg-opensource-src-5.4.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.0/submodules/qtsvg-opensource-src-5.4.0.tar.xz";
      sha256 = "12dpqb67mm1h1x3f4811zvk4dbnswsg58ipl57m3mdn7mhmpdvk8";
      name = "qtsvg-opensource-src-5.4.0.tar.xz";
    };
  }
]
