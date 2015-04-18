# This file is generated automatically. DO NOT EDIT!
{ stdenv, fetchurl, mirror }:
[
  {
    name = stdenv.lib.nameFromURL "qtwayland-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/32jn5sn8im7andkd6m15s95n48ald7pw-qtwayland-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwayland-opensource-src-5.4.1.tar.xz";
      sha256 = "14npf3lclkb83s8ywla67a1129ia1mbib145s1sk5gqw1dh5wfv5";
      name = "qtwayland-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtandroidextras-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/604ifwwrzpm96rffszyl11xjirm0w65j-qtandroidextras-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtandroidextras-opensource-src-5.4.1.tar.xz";
      sha256 = "0s12hmn2lnlbp7y47v344lyli6wh670dwazl3kkzv9vdv52df4wp";
      name = "qtandroidextras-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtgraphicaleffects-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/wcwaylvnlrfy6d6pc0ka7mkcam846cqb-qtgraphicaleffects-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtgraphicaleffects-opensource-src-5.4.1.tar.xz";
      sha256 = "071mz2w25g5svknb97y6yw55sq9171qqd92n3dp4w2qg2blg1qms";
      name = "qtgraphicaleffects-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtenginio-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/k7gayy35qqwbaf2yyr1lfydmsp6p9k3i-qtenginio-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtenginio-opensource-src-5.4.1.tar.xz";
      sha256 = "0yjpx43qy6yc6hblcrkp6g9jv2ipg2hdd27q86y7s30q54f17nxf";
      name = "qtenginio-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebengine-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/0y1p0ssxbd8wp4vyq5ad2f77inh07p1b-qtwebengine-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwebengine-opensource-src-5.4.1.tar.xz";
      sha256 = "1c5akxh6wxgc72md6802fbvd601n03assv6i542siwmmnp5anhij";
      name = "qtwebengine-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmacextras-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/0mdhndcp51g2160559kgd5a93c0c3317-qtmacextras-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtmacextras-opensource-src-5.4.1.tar.xz";
      sha256 = "0hivjn3yfidzj4la3rlrqzjawrakxyhc886w2jcf0bjz3vzl9xp2";
      name = "qtmacextras-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttranslations-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/hhana1500hq2h2l8815wq8rfrp7nizpb-qttranslations-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qttranslations-opensource-src-5.4.1.tar.xz";
      sha256 = "0hchmz7hjdjx0wn2v9sbgilvi0pigiriklw5pdvfxjabjxgh8k9w";
      name = "qttranslations-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebchannel-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/qfa1hycl1lh8pm2x65frxlms3waqbsfg-qtwebchannel-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwebchannel-opensource-src-5.4.1.tar.xz";
      sha256 = "0ldjyyp0ym3hndd0bq5mwjry2yilf1cv9iddqb8adz46k3nbkb64";
      name = "qtwebchannel-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdoc-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/hif7dg37sz0yjj09844f0gyqqsf9cpxx-qtdoc-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtdoc-opensource-src-5.4.1.tar.xz";
      sha256 = "1afg2lxyxgqhq02a58c9yshvkinlk5mw19yff1421fma6j925c8q";
      name = "qtdoc-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-examples-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/shz5132xvpp2hvmsyl1mhps0qanrgw43-qtwebkit-examples-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwebkit-examples-opensource-src-5.4.1.tar.xz";
      sha256 = "02kj4rw40s7xhdz1ixfy5fc7n5pr2ipqkpwj1kwng71l3jrpn60r";
      name = "qtwebkit-examples-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtbase-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/nl8rm1q2sqyq5y91h6d9dbks82krykn1-qtbase-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtbase-opensource-src-5.4.1.tar.xz";
      sha256 = "1dxigzgv6xj5lybs654y57ssfbl38dxff3s3wpvw0n89hf9sax45";
      name = "qtbase-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qttools-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/f9cbf92nhmfkz1q2n4nidh432s5d3pls-qttools-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qttools-opensource-src-5.4.1.tar.xz";
      sha256 = "0whzcwgzwh1m6fqb7h2gvkx9hi2ijjaz8ap36jqr8cc4ff2hzphi";
      name = "qttools-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qt5-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/hl5gzwaq43afs2z7ga10161myzz3xrwb-qt5-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qt5-opensource-src-5.4.1.tar.xz";
      sha256 = "01xgf3531q60vrkg1pp07q4p0ildj42zgnw63v8fnwjg7c5m59rd";
      name = "qt5-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquick1-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/9y9qhciiqys5sm502bbflqzrjmvxpqh6-qtquick1-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtquick1-opensource-src-5.4.1.tar.xz";
      sha256 = "0ba3r89j75vrjgh8h3ik64x84bhgbckc4bvy1wympwgfhk3j8lzb";
      name = "qtquick1-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebsockets-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/cmvv503q10qnmmbb8yxvvjlxpqqaswyb-qtwebsockets-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwebsockets-opensource-src-5.4.1.tar.xz";
      sha256 = "0i5bcxlwxbzq9k0kq1m90cbslby05x3j3r6js8xjarz2qnc6zxfs";
      name = "qtwebsockets-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsensors-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/9c4zpbngylc7cqqyai2ysglajapphxp7-qtsensors-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtsensors-opensource-src-5.4.1.tar.xz";
      sha256 = "1y6vbvvcgph466whcc896lkyk2lx8lyyqj1qnm76f3jjywp8wjxc";
      name = "qtsensors-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtx11extras-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/njkpa0ahd4l5307b4qmqlqiv4nw1by7z-qtx11extras-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtx11extras-opensource-src-5.4.1.tar.xz";
      sha256 = "0blcdqccxhdqj4v5zp6m34b74nw5n6pfgldyb6wrlpljkzdir9i0";
      name = "qtx11extras-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtmultimedia-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/q2ji7ilipdvx0p6iyrwhhfczzw1j11ws-qtmultimedia-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtmultimedia-opensource-src-5.4.1.tar.xz";
      sha256 = "0kjk3q7y2lr8a62rdidhn783jrq1rpj11p1jmfiw8z3j255dsc1q";
      name = "qtmultimedia-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtactiveqt-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/ikxpk38h1arms4x0qlnd7g5g3fg26fg4-qtactiveqt-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtactiveqt-opensource-src-5.4.1.tar.xz";
      sha256 = "14984cvh9cfnrgls40i28fjdhs015izzlvwck9va4167y3ix4zbx";
      name = "qtactiveqt-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtxmlpatterns-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/0a30a874s507fmrsd1jlggbh9j953jb9-qtxmlpatterns-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtxmlpatterns-opensource-src-5.4.1.tar.xz";
      sha256 = "062kqs8m9js8mlld1lsm01prq57zs88g7p8fad84a5gisgs2y57m";
      name = "qtxmlpatterns-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtscript-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/cbb46kpmk6radk9v8cyngxcxr11g06f6-qtscript-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtscript-opensource-src-5.4.1.tar.xz";
      sha256 = "1bybzcp9smasw0syvb7vrz85jq124r7gywz2msgjg1kb6z4aqcpl";
      name = "qtscript-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtquickcontrols-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/h5hg9z346lh2w8whf0zgq5kbwffpmnkk-qtquickcontrols-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtquickcontrols-opensource-src-5.4.1.tar.xz";
      sha256 = "1hpvbjr76q9i2idgmblr80khhjgkn78q0s0d648r3axp232m427y";
      name = "qtquickcontrols-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtimageformats-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/7vxgal1cag6cakigc7h3rjvvr64b7sd3-qtimageformats-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtimageformats-opensource-src-5.4.1.tar.xz";
      sha256 = "0vw4bg68kwp48v49ds2vxvgjc82i5q5scff4013y5gpbd2smnv1z";
      name = "qtimageformats-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtserialport-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/pgcv75a5x56s88qclqvbw04dzywcxm73-qtserialport-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtserialport-opensource-src-5.4.1.tar.xz";
      sha256 = "1zyhlpmh7yisk9qpk8map0myam4bkm4jvp0wcnd4d7pldf19xnbr";
      name = "qtserialport-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwebkit-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/p8jka7s4la8f83xqnl1a4ivdw95dajb8-qtwebkit-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwebkit-opensource-src-5.4.1.tar.xz";
      sha256 = "1gqrf5g07q5bgr3vnfnsw5qwqd0fjyh4pgqphrvxq4x9z0g221v6";
      name = "qtwebkit-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtconnectivity-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/ggn5pkvp89qh12vzhhk572s38vg3zn72-qtconnectivity-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtconnectivity-opensource-src-5.4.1.tar.xz";
      sha256 = "0q13gg7fmfb7cfq403ql8s5qi6s9a4fd86i7v9r6cwgnj2szzi42";
      name = "qtconnectivity-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtlocation-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/pnblj6ncfvz4id84asjlnrxb2papsn1v-qtlocation-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtlocation-opensource-src-5.4.1.tar.xz";
      sha256 = "113rx43349f7yn4crhgg6ciz6lyvfvfnc0vkdaz09a2r461hr7w8";
      name = "qtlocation-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtdeclarative-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/0bz5yxqc9yg94jyjkvsgn7h7lph99a5v-qtdeclarative-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtdeclarative-opensource-src-5.4.1.tar.xz";
      sha256 = "05s4imk7whm2qir9byb35dn2ndqb7c5r2cnxpv2qyjla58j4w4hm";
      name = "qtdeclarative-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtwinextras-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/xdbwakyhif8cjwyii7v32zkxlrbrksmc-qtwinextras-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtwinextras-opensource-src-5.4.1.tar.xz";
      sha256 = "01ddgvq8wny162njlzqnbphiiw565xsqy6h3s39cipa05c6mxblv";
      name = "qtwinextras-opensource-src-5.4.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "qtsvg-opensource-src-5.4.1.tar.xz" ".tar";
    store = "/nix/store/m3wk5r1ihbrjz9zpi57nllzqzha06c8j-qtsvg-opensource-src-5.4.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.4/5.4.1/submodules/qtsvg-opensource-src-5.4.1.tar.xz";
      sha256 = "0b71kngnq7c5ry8bkb0rjlr6xx49h1sd25m4i4s3v1rfrv6912my";
      name = "qtsvg-opensource-src-5.4.1.tar.xz";
    };
  }
]
