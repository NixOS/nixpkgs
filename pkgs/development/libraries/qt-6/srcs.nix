# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qt3d-everywhere-src-6.10.2.tar.xz";
      sha256 = "0vdvid42m9jyhmpclfgpc7j1ivxlj0jr23kp5pxa1v0z96fwmfzy";
      name = "qt3d-everywhere-src-6.10.2.tar.xz";
    };
  };
  qt5compat = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qt5compat-everywhere-src-6.10.2.tar.xz";
      sha256 = "1hk18428bpp60ypjzabzpc77nr10bzignqppqppvjbn0zbq1i91z";
      name = "qt5compat-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtactiveqt-everywhere-src-6.10.2.tar.xz";
      sha256 = "09swk8xv93gmk67v6zccxr3hjy4404q0awljfjlapas9xi10bnym";
      name = "qtactiveqt-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtbase = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtbase-everywhere-src-6.10.2.tar.xz";
      sha256 = "07pjmnwmlsbxc9zxgcazq9w4jnq6ypw50ndm7kamyaqs54lqvdxf";
      name = "qtbase-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtcharts = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtcharts-everywhere-src-6.10.2.tar.xz";
      sha256 = "001ckwq5w5w164cz2hkkb2dvci1d77mm9hf4hha9ivgdqns1cla0";
      name = "qtcharts-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtconnectivity-everywhere-src-6.10.2.tar.xz";
      sha256 = "0chs66537ki0yvq94m2i3k69wf8kyr741m4wg6vbamr8ychz0n6g";
      name = "qtconnectivity-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtdatavis3d-everywhere-src-6.10.2.tar.xz";
      sha256 = "1hav6ncccdhw2kyx608xhchpmygx6sbfap8x6ch35l53yj5l0sdp";
      name = "qtdatavis3d-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtdeclarative-everywhere-src-6.10.2.tar.xz";
      sha256 = "03sb1wfxqvy5dhyd85yc0776vvm2jzczlpwbvzqdpp3cyr7r2jd2";
      name = "qtdeclarative-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtdoc = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtdoc-everywhere-src-6.10.2.tar.xz";
      sha256 = "011pp0nf019dg790vhr9i3xiy6vspzjpr8w8xd9cpyk723nsj54c";
      name = "qtdoc-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtgraphs-everywhere-src-6.10.2.tar.xz";
      sha256 = "1bvsvmwf4csl63fqf4gdqb03s97b9dl0sdyffrp9mn37lmmgr47n";
      name = "qtgraphs-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtgrpc-everywhere-src-6.10.2.tar.xz";
      sha256 = "0dnibqlsnra4kwk1dng4g6rrndszx5kz1p12zzjj0y8cq74vz1kk";
      name = "qtgrpc-everywhere-src-6.10.2.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qthttpserver-everywhere-src-6.10.2.tar.xz";
      sha256 = "0hs6zq1qfs4yfr9bf2d089q37wcyhgvx48vq54szsn72prcqsmi6";
      name = "qthttpserver-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtimageformats-everywhere-src-6.10.2.tar.xz";
      sha256 = "0rwxcdpzx5mls7sqvscq58hb2h01j4qpy3h07ixiw21qhrqrr3wb";
      name = "qtimageformats-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtlanguageserver-everywhere-src-6.10.2.tar.xz";
      sha256 = "0lqdqknblw4nsv1mgi5jw6rqsf7h9zf59af7bw371d5hhhn3y14s";
      name = "qtlanguageserver-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtlocation = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtlocation-everywhere-src-6.10.2.tar.xz";
      sha256 = "0g0gwldmdslzx0zjdpi3vc0pqnd266qkxynh8xy534y5xmfz04yk";
      name = "qtlocation-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtlottie = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtlottie-everywhere-src-6.10.2.tar.xz";
      sha256 = "1302lh7432372qy0mw2pv67miikf2ny2n103s8mhyfl30xx6pn55";
      name = "qtlottie-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtmultimedia-everywhere-src-6.10.2.tar.xz";
      sha256 = "0aryhch6qlamgfcbrxc0d1ggq4f96vjg68r7b8b33mzv0q0yzxwk";
      name = "qtmultimedia-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtnetworkauth-everywhere-src-6.10.2.tar.xz";
      sha256 = "1cw1355xxf0ca96xwjaw33nnrxh1qw26naa2zha5fpsh9fggsaag";
      name = "qtnetworkauth-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtpositioning-everywhere-src-6.10.2.tar.xz";
      sha256 = "1kndqjh3ylbs5a2chqv3a6jip83j6zy9dlya82c7crkw8xjgllbh";
      name = "qtpositioning-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtquick3d-everywhere-src-6.10.2.tar.xz";
      sha256 = "0xfdlafzz7k3vps0kzz4mnyv0cmr0f5v8a4qkqvhqn0y3prkjm5r";
      name = "qtquick3d-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtquick3dphysics-everywhere-src-6.10.2.tar.xz";
      sha256 = "1nqw5kqrivmajbw2sqxll8zgqjk79g2pic8rghfkb52ps1xzdbxp";
      name = "qtquick3dphysics-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtquickeffectmaker-everywhere-src-6.10.2.tar.xz";
      sha256 = "1i62d7s6fl4lf92cfwljk7blirz82mv174k1d5nrw38c9qxz3jp3";
      name = "qtquickeffectmaker-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtquicktimeline-everywhere-src-6.10.2.tar.xz";
      sha256 = "0933sggxp28mybdr8wgfyny9m0c23h70f3fy1mwxy7yjb2vxhckh";
      name = "qtquicktimeline-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtremoteobjects-everywhere-src-6.10.2.tar.xz";
      sha256 = "1kb5xd1ckp4phq820rl9h6nbaryrybzk2zxlq83cykg79w23ys5w";
      name = "qtremoteobjects-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtscxml = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtscxml-everywhere-src-6.10.2.tar.xz";
      sha256 = "0si3vpzva8wyqa0gh0fyk75knlgmsyjalahp41nv1cginf6ig70g";
      name = "qtscxml-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtsensors = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtsensors-everywhere-src-6.10.2.tar.xz";
      sha256 = "10gmis63gpqhbb7ljy1gx3gh7hww6psk66c6jqvaxgzbgidm3rli";
      name = "qtsensors-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtserialbus-everywhere-src-6.10.2.tar.xz";
      sha256 = "0yrsg50gmjlxnp1574fzkfbxls1cmjkn1qpagayhx55nrzzbydj7";
      name = "qtserialbus-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtserialport = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtserialport-everywhere-src-6.10.2.tar.xz";
      sha256 = "0sxxvrn1bwrzm140988prn12f14pj15v8z3yxs7zl7qiv8lvy35l";
      name = "qtserialport-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtshadertools-everywhere-src-6.10.2.tar.xz";
      sha256 = "1j8ncwhjcy2k6p05cldnb20vbqijq1frdac9xpk9cvky9yydpn8q";
      name = "qtshadertools-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtspeech = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtspeech-everywhere-src-6.10.2.tar.xz";
      sha256 = "051h4v0qqjkz1brkypx6i2wzdpn8pwz5353f0f7hsavr2p3zcdyr";
      name = "qtspeech-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtsvg = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtsvg-everywhere-src-6.10.2.tar.xz";
      sha256 = "1qfnv8ssflndjhv6r8s9vxfl8yblra956d00f8c3bwna707zhzzh";
      name = "qtsvg-everywhere-src-6.10.2.tar.xz";
    };
  };
  qttools = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qttools-everywhere-src-6.10.2.tar.xz";
      sha256 = "092vimkdpad6q9dilkhc45wmzzzs5ykfmbkfbi1d4xpxq43jqg8y";
      name = "qttools-everywhere-src-6.10.2.tar.xz";
    };
  };
  qttranslations = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qttranslations-everywhere-src-6.10.2.tar.xz";
      sha256 = "0i56a03b7f6snvxfjsa5q4mnw6x7kxjnx2yw2rbm8sypr4xq3cxk";
      name = "qttranslations-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtvirtualkeyboard-everywhere-src-6.10.2.tar.xz";
      sha256 = "0swqvcgp6p80k2g7nzb6dcjr2spxcj4lk48s7ll3ygx8j5h2awv2";
      name = "qtvirtualkeyboard-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtwayland = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtwayland-everywhere-src-6.10.2.tar.xz";
      sha256 = "1qkyabklzzzbh4ryxhbnvnpz52vzqvyqwzd6lqkdy6978gmrh69r";
      name = "qtwayland-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtwebchannel-everywhere-src-6.10.2.tar.xz";
      sha256 = "09rc9y51bdb46pj7wad59gycy2l4ki3siizxai6kgq0risgsa7p3";
      name = "qtwebchannel-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtwebengine-everywhere-src-6.10.2.tar.xz";
      sha256 = "07ln4f89qlxvsxg5gjwvwqhcfkhvf5kympk7hmhqi6m6jbrdsvl5";
      name = "qtwebengine-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtwebsockets-everywhere-src-6.10.2.tar.xz";
      sha256 = "1g9fnj73q3s8a49qzhr1iv2h7z50hwwnja80s9bgd7jhx8dpbk7c";
      name = "qtwebsockets-everywhere-src-6.10.2.tar.xz";
    };
  };
  qtwebview = {
    version = "6.10.2";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.10/6.10.2/submodules/qtwebview-everywhere-src-6.10.2.tar.xz";
      sha256 = "1d7as06xmbmjx1rfnhrvizhy85dz3xdlx3pzy370r44q17zhdi3y";
      name = "qtwebview-everywhere-src-6.10.2.tar.xz";
    };
  };
}
