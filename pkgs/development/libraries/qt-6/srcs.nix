# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qt3d-everywhere-src-6.11.0.tar.xz";
      sha256 = "086xpissihbil51ryl83dlcpkpv3pp3ryj0712x9k9z6756j7ks0";
      name = "qt3d-everywhere-src-6.11.0.tar.xz";
    };
  };
  qt5compat = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qt5compat-everywhere-src-6.11.0.tar.xz";
      sha256 = "0gn6sj136y8yl1c00nbm81rmhws0mgx35ny7llx74j97ddj58ag6";
      name = "qt5compat-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtactiveqt-everywhere-src-6.11.0.tar.xz";
      sha256 = "1kbqa0gx41s097281g4zym9jmjs2ffc75p3rgkbs6bvnlrvl0h89";
      name = "qtactiveqt-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtbase = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtbase-everywhere-src-6.11.0.tar.xz";
      sha256 = "0pkmrd8ypw1v21cx0890gc6z4v0xr5qip2jnr56r2kc6g5cxh6i3";
      name = "qtbase-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtcanvaspainter = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtcanvaspainter-everywhere-src-6.11.0.tar.xz";
      sha256 = "1gmgzmh81wrnj81xsmilqwhc1wv7j2avg91mww8jlrv5rplzynjl";
      name = "qtcanvaspainter-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtcharts = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtcharts-everywhere-src-6.11.0.tar.xz";
      sha256 = "1dcldlw24qd9swynxcdsxnk8haiv442wx323j7qgfwjp13a9nh5c";
      name = "qtcharts-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtconnectivity-everywhere-src-6.11.0.tar.xz";
      sha256 = "0fhrqqz58h3smkksfgnax73bmsiz7q9a1w9vhwd83vs9r0jc3w60";
      name = "qtconnectivity-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtdatavis3d-everywhere-src-6.11.0.tar.xz";
      sha256 = "1jr3bkvp4wj1jdafc64ziq4raxbya6jk6s0d4mq0w2kr7zpqrggf";
      name = "qtdatavis3d-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtdeclarative-everywhere-src-6.11.0.tar.xz";
      sha256 = "1sgxxmg49flana7mylyz4c5mf5hr00kzl8nkwwj87pqx8dlybv2f";
      name = "qtdeclarative-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtdoc = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtdoc-everywhere-src-6.11.0.tar.xz";
      sha256 = "1wwl2vr1qs2lqmz45iqpkzkxqp97g0yzfmz0kb5wpi8sys7c07bx";
      name = "qtdoc-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtgraphs = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtgraphs-everywhere-src-6.11.0.tar.xz";
      sha256 = "0nxifvs5042pzyd5syhgpmxzsq07fhpbbm57ckwzsn55q14cnvyz";
      name = "qtgraphs-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtgrpc-everywhere-src-6.11.0.tar.xz";
      sha256 = "0yd8jjxigaynv386f3cs1i743nm7yngciw346xqfil3chd8wpvcx";
      name = "qtgrpc-everywhere-src-6.11.0.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qthttpserver-everywhere-src-6.11.0.tar.xz";
      sha256 = "16wqglm8ws63qs7i769xy94bygwbhkz7hjfw27hnps7d4yirb41b";
      name = "qthttpserver-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtimageformats-everywhere-src-6.11.0.tar.xz";
      sha256 = "1j0cjj7gxjbprszw349janl3zk38rkby1bmxil329zp2qlmb1bfk";
      name = "qtimageformats-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtlanguageserver-everywhere-src-6.11.0.tar.xz";
      sha256 = "1gq5yjvk6iyg606pgpxkb136qlz9hpb7ngll81nhiyb1ym1y9j0v";
      name = "qtlanguageserver-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtlocation = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtlocation-everywhere-src-6.11.0.tar.xz";
      sha256 = "1vxb6n8xf98zcg2bw29gsaqa74sg6jn9ilzs8c5b9q79i9m3if49";
      name = "qtlocation-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtlottie = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtlottie-everywhere-src-6.11.0.tar.xz";
      sha256 = "02ndplkk4bq01b0fh9l2ykw09v0k5nbsayrs9wcjwrdwg5law8rg";
      name = "qtlottie-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtmultimedia-everywhere-src-6.11.0.tar.xz";
      sha256 = "0h30l8zflkla7rcshgs0jfjbjwvq9rqx0wq83f6vd0x9lz0cmi4h";
      name = "qtmultimedia-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtnetworkauth-everywhere-src-6.11.0.tar.xz";
      sha256 = "1mqly8had79f54dlygh42jr0c0jfiv4j4w2rbr0s7qx9nk9ig342";
      name = "qtnetworkauth-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtopenapi = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtopenapi-everywhere-src-6.11.0.tar.xz";
      sha256 = "1h2pcq6i72yic0r7ns36vj678d1xqy291jamqd6b6jkjddmj1hlg";
      name = "qtopenapi-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtpositioning-everywhere-src-6.11.0.tar.xz";
      sha256 = "1scnnz65qyfg0nl9vjkqcss8xsw3yf91w71d9p1kwlfybscd07yn";
      name = "qtpositioning-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtquick3d-everywhere-src-6.11.0.tar.xz";
      sha256 = "1549gdb3yxj1bpl54kgnkkhzjx0zxqi71ssp4rj6qnz56fxh085l";
      name = "qtquick3d-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtquick3dphysics-everywhere-src-6.11.0.tar.xz";
      sha256 = "0dcx9913xss435cijx5bzckvsn66qfi6c39rx0gyv9iiys76qym5";
      name = "qtquick3dphysics-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtquickeffectmaker-everywhere-src-6.11.0.tar.xz";
      sha256 = "05fpv497rmx2lw7gx05sxyxjwx8gq8fbbnkzhnw73pk2xqzq20mc";
      name = "qtquickeffectmaker-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtquicktimeline-everywhere-src-6.11.0.tar.xz";
      sha256 = "1micycw7m25gw0bgbfq7bnr7cg7qrjj2r69320rglc8lak6f3nq6";
      name = "qtquicktimeline-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtremoteobjects-everywhere-src-6.11.0.tar.xz";
      sha256 = "15yykbaxqc6v2flgjvn92w7gwfvi820dg4cxkjxcfhpix2m21571";
      name = "qtremoteobjects-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtscxml = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtscxml-everywhere-src-6.11.0.tar.xz";
      sha256 = "1rylchpvzldy7hhr3icr85w8m4hf7wch17yqh368yrn3q19klf3c";
      name = "qtscxml-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtsensors = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtsensors-everywhere-src-6.11.0.tar.xz";
      sha256 = "1iy33w7gjp06xi4342si979q9w84cvbbk90kxmk2gx69icjjja21";
      name = "qtsensors-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtserialbus-everywhere-src-6.11.0.tar.xz";
      sha256 = "1qfs9zqvz3hf16w8gg6nlwxcv6sz72546pds02dabhkcw47nqvmh";
      name = "qtserialbus-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtserialport = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtserialport-everywhere-src-6.11.0.tar.xz";
      sha256 = "111pmva70mcffhq09q2h1gcr03fivs9j2ywx4ib00pbyxfvr4ii6";
      name = "qtserialport-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtshadertools-everywhere-src-6.11.0.tar.xz";
      sha256 = "0jp1sb9pl7y821awln7rpk0hz7d5ipwnkqhy51caich9i2pb2g74";
      name = "qtshadertools-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtspeech = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtspeech-everywhere-src-6.11.0.tar.xz";
      sha256 = "08fv8v6rvcv0pa6r52kr2na2rcpjr3yk556ksinnh6aslv8qbid9";
      name = "qtspeech-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtsvg = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtsvg-everywhere-src-6.11.0.tar.xz";
      sha256 = "1rih59jsn0wq12gq5gbs1cz9by27x2x4wjpd0ya7s207pr9xda6z";
      name = "qtsvg-everywhere-src-6.11.0.tar.xz";
    };
  };
  qttasktree = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qttasktree-everywhere-src-6.11.0.tar.xz";
      sha256 = "0kxkm3qvzw5i5x2ads6skpz8z6shbn2msznmr614yvsdgiga4yjr";
      name = "qttasktree-everywhere-src-6.11.0.tar.xz";
    };
  };
  qttools = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qttools-everywhere-src-6.11.0.tar.xz";
      sha256 = "0xpwv483zrw3jkajhv9sbr7bm95qahxg770vn1jqk10hg8yrkcfg";
      name = "qttools-everywhere-src-6.11.0.tar.xz";
    };
  };
  qttranslations = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qttranslations-everywhere-src-6.11.0.tar.xz";
      sha256 = "0mpy3y76n1jw2prhad9rqyn48miqlmqg3581jgzr4s1iwhpqpx2l";
      name = "qttranslations-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtvirtualkeyboard-everywhere-src-6.11.0.tar.xz";
      sha256 = "11p6m1s7r7q2y6a2ak5lyzfd2907s2skfa630snf64x32cblp2nq";
      name = "qtvirtualkeyboard-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtwayland = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtwayland-everywhere-src-6.11.0.tar.xz";
      sha256 = "0dsdv1d4p1wf0sqd26cmj486bvwlprmqzmjddsw24agrc3kyc477";
      name = "qtwayland-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtwebchannel-everywhere-src-6.11.0.tar.xz";
      sha256 = "097vm6pxh18bil9ld9cxg50v861nyhaha4f6bjfjqph1icx18ip9";
      name = "qtwebchannel-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtwebengine-everywhere-src-6.11.0.tar.xz";
      sha256 = "0dk72k92zp19jkph1vl88l2dyrh105v6cycsxln1anfxnb423fb3";
      name = "qtwebengine-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtwebsockets-everywhere-src-6.11.0.tar.xz";
      sha256 = "0cnh67ncfh0gvpqfiqhr0cpmswq9zysza130axlmh69mzg8i17sn";
      name = "qtwebsockets-everywhere-src-6.11.0.tar.xz";
    };
  };
  qtwebview = {
    version = "6.11.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.11/6.11.0/submodules/qtwebview-everywhere-src-6.11.0.tar.xz";
      sha256 = "1cy4x331h0f4d5l8c18xrvdq6hwz7r16qd1xhr8gdm8j9bcsw3nb";
      name = "qtwebview-everywhere-src-6.11.0.tar.xz";
    };
  };
}
