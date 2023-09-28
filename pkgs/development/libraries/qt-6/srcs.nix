# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6
{ fetchurl, mirror }:

{
  qt3d = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qt3d-everywhere-src-6.5.3.tar.xz";
      sha256 = "1p7x70wnqynsvd7w4jkz31amf02hwh49gqsccv5hhlpx50h9ydhd";
      name = "qt3d-everywhere-src-6.5.3.tar.xz";
    };
  };
  qt5compat = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qt5compat-everywhere-src-6.5.3.tar.xz";
      sha256 = "0r34h35w0m17zyncxq2a0kichv5l4j01mximg6m5mqbifziakcpf";
      name = "qt5compat-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtactiveqt = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtactiveqt-everywhere-src-6.5.3.tar.xz";
      sha256 = "1lawc0jq5w0jqjagkf7d0g9i8rrsdgrd4k34ylriy27djpd53b1j";
      name = "qtactiveqt-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtbase = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtbase-everywhere-src-6.5.3.tar.xz";
      sha256 = "0imm0x9j7102ymcz7gl0dbnbi8qk2jmijb4gg7wh9sp41cillbyz";
      name = "qtbase-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtcharts = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtcharts-everywhere-src-6.5.3.tar.xz";
      sha256 = "1n9fflfh47wm0fk1995dw56vyqfprwv5ialjfpcxxgzm187816sa";
      name = "qtcharts-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtconnectivity = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtconnectivity-everywhere-src-6.5.3.tar.xz";
      sha256 = "0nrzpqs3cq0inwp3siskxz9yxxqkz15yaf9aicnggvvic2q328i4";
      name = "qtconnectivity-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtdatavis3d-everywhere-src-6.5.3.tar.xz";
      sha256 = "0qf07m3bplqpm7pkn3145l2k9h0npv9qbw9gcnydzp0qdsqc1dhi";
      name = "qtdatavis3d-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtdeclarative = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtdeclarative-everywhere-src-6.5.3.tar.xz";
      sha256 = "05fjb70n35y42dp7g0sd99rbvmn9133z08k6rlp8ifq6sb9dcka0";
      name = "qtdeclarative-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtdoc = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtdoc-everywhere-src-6.5.3.tar.xz";
      sha256 = "1k430zc8khakpcjbj7vmkgrdyrz0y6bfcfgw4dzc68gcvbwbq27g";
      name = "qtdoc-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtgrpc = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtgrpc-everywhere-src-6.5.3.tar.xz";
      sha256 = "10wbq5zcr263g1hi06xpyvh7y2advhhy07asx4aqwf56v9rpmgvf";
      name = "qtgrpc-everywhere-src-6.5.3.tar.xz";
    };
  };
  qthttpserver = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qthttpserver-everywhere-src-6.5.3.tar.xz";
      sha256 = "0ivcaqf39k7mawd17wf2db3kn8ch2ajm4gqm6wl1iqkp45aqjm05";
      name = "qthttpserver-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtimageformats = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtimageformats-everywhere-src-6.5.3.tar.xz";
      sha256 = "1jwc2gzlymxx82khwbaav83ma8y1rl2v593jq0jd13kkkb22dh29";
      name = "qtimageformats-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtlanguageserver = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtlanguageserver-everywhere-src-6.5.3.tar.xz";
      sha256 = "12i1g8inp667w95gx4ldc3shb3pjd65c1x74qhmr6k2mq1sc3h60";
      name = "qtlanguageserver-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtlocation = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtlocation-everywhere-src-6.5.3.tar.xz";
      sha256 = "1k77ck556wkcjzly2z2p9da54hpf8x5mjhyjvn6039xzjzax232k";
      name = "qtlocation-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtlottie = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtlottie-everywhere-src-6.5.3.tar.xz";
      sha256 = "08jpm4vhcwh0a72np6fmws79v9k3dpsji5gd3ws1rh04n62lcb1x";
      name = "qtlottie-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtmultimedia = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtmultimedia-everywhere-src-6.5.3.tar.xz";
      sha256 = "09zzl3wywhnz5a0ym3q7nbydjcq2vj2bz7gi5p8hrhlqpg9g6r7d";
      name = "qtmultimedia-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtnetworkauth = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtnetworkauth-everywhere-src-6.5.3.tar.xz";
      sha256 = "00m71302b1m4hjzn0hv222yz1d8dvm9n5djgyn38ikazb5smvd1n";
      name = "qtnetworkauth-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtpositioning = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtpositioning-everywhere-src-6.5.3.tar.xz";
      sha256 = "13vdklh87jz2p3miaifffi6r0ciw191b9ciaicwk0wry5fdhj6mb";
      name = "qtpositioning-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtquick3d = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtquick3d-everywhere-src-6.5.3.tar.xz";
      sha256 = "0pffi1wcai6d5w18v39fdwp74za6ydjjcgbgn84y939h7xham0k6";
      name = "qtquick3d-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtquick3dphysics = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtquick3dphysics-everywhere-src-6.5.3.tar.xz";
      sha256 = "1fm4ll8cjbdjn35pbi4763sfxzj49gml2rkdr7mrzwrz4hfk149j";
      name = "qtquick3dphysics-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtquickeffectmaker = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtquickeffectmaker-everywhere-src-6.5.3.tar.xz";
      sha256 = "19wwmal5k00l54ybb1ml2c40r4y5a1cwkd36zlri9jycs6x9nrxr";
      name = "qtquickeffectmaker-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtquicktimeline = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtquicktimeline-everywhere-src-6.5.3.tar.xz";
      sha256 = "0nvv5v5dy3ga1c1whrqdwvicmkys0psb720jycq833yqazn4qgpv";
      name = "qtquicktimeline-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtremoteobjects = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtremoteobjects-everywhere-src-6.5.3.tar.xz";
      sha256 = "18g78q2b9iabc1a9sgbksxj2nsiizaq4lfmxqljjq2cbzd09x74d";
      name = "qtremoteobjects-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtscxml = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtscxml-everywhere-src-6.5.3.tar.xz";
      sha256 = "0ld7i84nxxzp3bm96v2ymg53kkb8fpws2vq8b5bibs2zq0m6gn7k";
      name = "qtscxml-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtsensors = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtsensors-everywhere-src-6.5.3.tar.xz";
      sha256 = "14y25lp296vddk3n4wpf8glshfww73dg47khhvw4s4l3b8rsgl8r";
      name = "qtsensors-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtserialbus = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtserialbus-everywhere-src-6.5.3.tar.xz";
      sha256 = "13fhm8r0zp8rhbcn9i01s73kdng8afdvh5y0grqw8xqd2ncrav91";
      name = "qtserialbus-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtserialport = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtserialport-everywhere-src-6.5.3.tar.xz";
      sha256 = "1njfhj063gw7v05ynw4frgwisl2cnlkd4xk2yf22hhmiihwsvjwr";
      name = "qtserialport-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtshadertools = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtshadertools-everywhere-src-6.5.3.tar.xz";
      sha256 = "0wrm1yp90fdqwvw8chxd2diic8zl1akr1yyyqmw8w14z80x7n6r0";
      name = "qtshadertools-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtspeech = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtspeech-everywhere-src-6.5.3.tar.xz";
      sha256 = "170bdch6hvmqkf4y3071ym9aqbmknn0mdbayh9rpw6lj9lng9hkr";
      name = "qtspeech-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtsvg = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtsvg-everywhere-src-6.5.3.tar.xz";
      sha256 = "1vsvbpwh8k863nb94lrl0l8phma176b1kcfl7i3q07yad5xw8hgw";
      name = "qtsvg-everywhere-src-6.5.3.tar.xz";
    };
  };
  qttools = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qttools-everywhere-src-6.5.3.tar.xz";
      sha256 = "0dsy82k7ds5yziy648mxwfz6nq2vq90g43cbnjxjarv97wmx74gw";
      name = "qttools-everywhere-src-6.5.3.tar.xz";
    };
  };
  qttranslations = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qttranslations-everywhere-src-6.5.3.tar.xz";
      sha256 = "1qs9x52fqnsgk1wzrvihnr6c5cigx8zimhk3dy1qxhprvh6lrd43";
      name = "qttranslations-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtvirtualkeyboard-everywhere-src-6.5.3.tar.xz";
      sha256 = "0bg678dirmw5b3d46abbidkch0p5hchmqgiwvcvxfh3928aqz01i";
      name = "qtvirtualkeyboard-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtwayland = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtwayland-everywhere-src-6.5.3.tar.xz";
      sha256 = "17rnaap0xa0c6q8b0drm020qny0i3ia8nb0z66xq36zzny48aapp";
      name = "qtwayland-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtwebchannel = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtwebchannel-everywhere-src-6.5.3.tar.xz";
      sha256 = "0jphdg711lhxbxg4dqrxnvkmfr2q9xzrd0h525zw94m7mfk8k7qj";
      name = "qtwebchannel-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtwebengine = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtwebengine-everywhere-src-6.5.3.tar.xz";
      sha256 = "1ra5hyyg4vymp8pgzv08smjc3fl1axdavnkpj1i5zxym1ndww513";
      name = "qtwebengine-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtwebsockets = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtwebsockets-everywhere-src-6.5.3.tar.xz";
      sha256 = "1hx7qy7rgs46ggzifp249d8zz27bjwmbv7f960lwymjdb4bsxqh4";
      name = "qtwebsockets-everywhere-src-6.5.3.tar.xz";
    };
  };
  qtwebview = {
    version = "6.5.3";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/6.5/6.5.3/submodules/qtwebview-everywhere-src-6.5.3.tar.xz";
      sha256 = "0jbiwwhjp4lz4r3ym3a4wr3s966d6imffmpb0jlvkah9ji6g276g";
      name = "qtwebview-everywhere-src-6.5.3.tar.xz";
    };
  };
}
