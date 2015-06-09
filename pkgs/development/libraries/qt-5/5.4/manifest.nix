# This file is generated automatically. DO NOT EDIT!
{ stdenv, fetchurl, mirror }:
[
  {
    name = stdenv.lib.nameFromURL "qtbase-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/60xy2xnsl5kwraqkgh8d950nj1pk3kmi-qtbase-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtbase-opensource-src-5.4.2.tar.xz";
      sha256 = "0x2szpjjvsrpcqw0dd3gsim7b1jv9p716pnllzjbia5mp0hggi4z";
      name = "qtbase-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtenginio-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/4iprnq6sm0b1pnxmxb5krip7kk40xqmr-qtenginio-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtenginio-opensource-src-5.4.2.tar.xz";
      sha256 = "082i3fapjw6xs0jkz7x529dn3pb6w1pfli3cjrgvggff86gwlgwn";
      name = "qtenginio-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtserialport-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/l9k1v23ddnhjch5b2p3l28xbqkhz63yl-qtserialport-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtserialport-opensource-src-5.4.2.tar.xz";
      sha256 = "1h6p5rb0ldxgzd4md3n79gy0j9blhj736670xqjd9vlvh1743kck";
      name = "qtserialport-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtscript-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/n4ixnakw3fiflyimshkp43h7ijlpiif6-qtscript-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtscript-opensource-src-5.4.2.tar.xz";
      sha256 = "0izsmy0cr8iii78r10ndkidyljxqd2k9g03f5xb9nxacvr2f8hp0";
      name = "qtscript-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebchannel-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/qbkqkn4ck0fqbndl9fzp7iaz6c475xq8-qtwebchannel-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwebchannel-opensource-src-5.4.2.tar.xz";
      sha256 = "0vy1zjbghfa1wirxd8fd2n2n8yryykzr09913qm2nlfbcxdsgqsn";
      name = "qtwebchannel-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwinextras-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/9kmig3lg8d8s5r1jl3xj5q3jrkp3p8sx-qtwinextras-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwinextras-opensource-src-5.4.2.tar.xz";
      sha256 = "0sgybvr1y2xsddlqc95ninxj3rfmd4gv7a8f7rqcxdynjan5gij0";
      name = "qtwinextras-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebsockets-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/zk4s5pgp3mh6xdq6z3svi305vn0pli27-qtwebsockets-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwebsockets-opensource-src-5.4.2.tar.xz";
      sha256 = "0lv1la8333qnirxmscs42xnnra0xry1gjbhi3bxrf1hrfs2im9j4";
      name = "qtwebsockets-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmultimedia-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/n8wpy6b8jw1rf51z1qhxbbym7j8rr8ay-qtmultimedia-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtmultimedia-opensource-src-5.4.2.tar.xz";
      sha256 = "0h29cs8ajnjarhjx1aczdnxqwvg6pqs9s8w28hw488s149wqqrnj";
      name = "qtmultimedia-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtgraphicaleffects-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/2q2vk530mf32zzd1v8bpax8iixviw6q5-qtgraphicaleffects-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtgraphicaleffects-opensource-src-5.4.2.tar.xz";
      sha256 = "02p8xm5ajicjam30ry3g1lm2p4nja2q0sls8dzimqrxhw5xlg3xs";
      name = "qtgraphicaleffects-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtxmlpatterns-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/3fqgpa668hb1xmwjw056cw58qzb3r0g4-qtxmlpatterns-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtxmlpatterns-opensource-src-5.4.2.tar.xz";
      sha256 = "0ar7znqp1i02ha5ngy2kzk3hlgkafjbn2xa8j2k78gzmwsmdhzxa";
      name = "qtxmlpatterns-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttranslations-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/mg9b5z2nznzxrz501hm06b7l27jjwaca-qttranslations-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qttranslations-opensource-src-5.4.2.tar.xz";
      sha256 = "0b4l69c16z8gjd4mq75zz3lj2gxarr9wyk0vk60jg1mi62vxvdls";
      name = "qttranslations-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdeclarative-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/bjmv4fgphx9bggzcwy4lcdas9phbwjsg-qtdeclarative-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtdeclarative-opensource-src-5.4.2.tar.xz";
      sha256 = "1bj1wwms6lpj8s70y8by3j0hjsw6g9v8m6fybx68krzzizbj2c5p";
      name = "qtdeclarative-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/pfhq8ask8jhzdh2x882d014b10ddywma-qtwebkit-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwebkit-opensource-src-5.4.2.tar.xz";
      sha256 = "0vffbpiczag2n2hp5gc0nii8n7vkidr8f8pp8a47px0183hl6hiy";
      name = "qtwebkit-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquick1-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/n807cxddkvhbzw3ciqs29zc5mw47z2qs-qtquick1-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtquick1-opensource-src-5.4.2.tar.xz";
      sha256 = "0178z15a31fw3l6933fwxs7sk0csifpwckydp3rqnn3fg5f2fwvp";
      name = "qtquick1-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquickcontrols-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/gq8afk8zr2vrrsfmp4caqv02209qk9xb-qtquickcontrols-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtquickcontrols-opensource-src-5.4.2.tar.xz";
      sha256 = "137z3c3drxlvkdfc7zgcl0xqmavw0ladzqy0i3bq51h756qdc877";
      name = "qtquickcontrols-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtimageformats-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/cmpx0338z1j0wzk6scfpay5k10023d46-qtimageformats-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtimageformats-opensource-src-5.4.2.tar.xz";
      sha256 = "1nny6j9pm5ri3n1vwl5lrfrdz0fl81rx127wa49rkg2rjai2aawb";
      name = "qtimageformats-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdoc-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/jv4wgs6pz9xqmin9m4q4mifr2vfcjn3h-qtdoc-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtdoc-opensource-src-5.4.2.tar.xz";
      sha256 = "15lamv6jvd7v33ldpcrazcdksv6qibdcgh4ncbyh774k8avgrlh8";
      name = "qtdoc-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwayland-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/qa3yi9lyx2dm4wqzb3qzvzba1sgnj74z-qtwayland-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwayland-opensource-src-5.4.2.tar.xz";
      sha256 = "14pmpkfq70plw07igxjaiji4vnjg5kg7izlb0wwym1lisg7bwkg0";
      name = "qtwayland-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmacextras-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/wdq1z3bzr9n11yln8avx10sgzgyvp8cl-qtmacextras-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtmacextras-opensource-src-5.4.2.tar.xz";
      sha256 = "0h0p3s0rvd3g9rgr4hwcggdbsav2g30vijqwmdxgxd8c00yply80";
      name = "qtmacextras-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtactiveqt-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/0ik7vc3zwdjvrp4fpyqf1zpyqdxvvqvq-qtactiveqt-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtactiveqt-opensource-src-5.4.2.tar.xz";
      sha256 = "014kwficqydciwdm1yw88yms81qm8pmi6xfhhfpbc9k85pc6jlla";
      name = "qtactiveqt-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtlocation-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/sa4dawsw2wv45ld3afbz9nfc64qkyx1s-qtlocation-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtlocation-opensource-src-5.4.2.tar.xz";
      sha256 = "1v43hl2zzi90vaw11y8dvsksrjn0r2v0br7pw6njl8lqadpg4jnw";
      name = "qtlocation-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtconnectivity-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/v2aiscvf582azyzg696rglway56l7xl2-qtconnectivity-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtconnectivity-opensource-src-5.4.2.tar.xz";
      sha256 = "1nj68bzgm3r1gg171kj0acnifzb3jx0m5pf4f81xb7zl4hfxasrs";
      name = "qtconnectivity-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtx11extras-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/nz62qld9h96z5a0b7fg52fsh5d6q0kqw-qtx11extras-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtx11extras-opensource-src-5.4.2.tar.xz";
      sha256 = "0jgyywjxavfpiz8202g3s0g9izfl185mmak4fs9h80w1i3gn5zzn";
      name = "qtx11extras-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttools-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/i8n6xrhalg3z4i0min4w79rq9h9hch0x-qttools-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qttools-opensource-src-5.4.2.tar.xz";
      sha256 = "1d5nx01r7wxhdg9f1i9xhsvsbwgaz3yv516s068riy970bhdgwzd";
      name = "qttools-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsensors-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/0ar28gp8klqxynjnc1r4kj9x7g8cknk2-qtsensors-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtsensors-opensource-src-5.4.2.tar.xz";
      sha256 = "1yawvjbdymgw8af7ir9zcin89xxck9dm2l6hnc43lwrky0frcvcf";
      name = "qtsensors-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebengine-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/ikr8cc3bn62jlv9afpzhxvqs5qhsc2yc-qtwebengine-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwebengine-opensource-src-5.4.2.tar.xz";
      sha256 = "06cyl733prakniqrn8sd807lclk5im2vmysjdcijry2mcyah2ih8";
      name = "qtwebengine-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsvg-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/0llm31zpiaqig940a8dsp1dk2npxsnjc-qtsvg-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtsvg-opensource-src-5.4.2.tar.xz";
      sha256 = "1dsyncp154xvb7d82nmnfjm0ngymnhqmliq58ljwxsjmpjlncakz";
      name = "qtsvg-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qt5-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/0jrx1clg8vqid9b2n9z8f0xbwjm0yynr-qt5-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qt5-opensource-src-5.4.2.tar.xz";
      sha256 = "17a0pybr4bpyv9pj7cr5hl4g31biv89bjr8zql723h0b12ql1w44";
      name = "qt5-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-examples-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/6pmmi9bjbdxkbw2xkkc1srk5ambnjcxv-qtwebkit-examples-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtwebkit-examples-opensource-src-5.4.2.tar.xz";
      sha256 = "0pm9ik1j09jfb5xflc16449nff2xsfyfms7vxlcdjg4dhcqfmll8";
      name = "qtwebkit-examples-opensource-src-5.4.2.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtandroidextras-opensource-src-5.4.2.tar.xz" ".tar";
    store = "/nix/store/grrsklibvplaj5pdwjp2zirxmqnq10hf-qtandroidextras-opensource-src-5.4.2.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.2/submodules/qtandroidextras-opensource-src-5.4.2.tar.xz";
      sha256 = "0krfm0wg26x7575p8isswdhrkb0jxyp169grwklil7mfw8yg3xhx";
      name = "qtandroidextras-opensource-src-5.4.2.tar.xz";
    };
  }
]
