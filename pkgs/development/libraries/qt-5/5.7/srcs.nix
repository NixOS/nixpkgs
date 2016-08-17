# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
  qtwebkit = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/community_releases/5.7/5.7.0/qtwebkit-opensource-src-5.7.0.tar.xz";
      sha256 = "1prlpl3zslzpr1iv7m3irvxjxn3v8nlxh21v9k2kaq4fpwy2b8y7";
      name = "qtwebkit-opensource-src-5.7.0.tar.xz";
    };
  };
  qt3d = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qt3d-opensource-src-5.7.0.tar.xz";
      sha256 = "0a9y4fxm4xmdl5hsv4hfvxcw7jmshy0mwd4j1r2ylqdmg4bql958";
      name = "qt3d-opensource-src-5.7.0.tar.xz";
    };
  };
  qtactiveqt = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtactiveqt-opensource-src-5.7.0.tar.xz";
      sha256 = "149wj6a5i35k750129kz77y4r8q3hpxqzn1c676fcn9wpmfhay4v";
      name = "qtactiveqt-opensource-src-5.7.0.tar.xz";
    };
  };
  qtandroidextras = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtandroidextras-opensource-src-5.7.0.tar.xz";
      sha256 = "1caimhfyag96v98j1b07pfzjl5inhsyfi9kxzy9nj0pkvpjdgi4g";
      name = "qtandroidextras-opensource-src-5.7.0.tar.xz";
    };
  };
  qtbase = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtbase-opensource-src-5.7.0.tar.xz";
      sha256 = "0ip6xnizsn269r4s1nq9lkx8cdxkjqr1fidwrj3sa8xb7h96syry";
      name = "qtbase-opensource-src-5.7.0.tar.xz";
    };
  };
  qtcanvas3d = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtcanvas3d-opensource-src-5.7.0.tar.xz";
      sha256 = "15xxwciyiy8rwrwgb7bgcbxdiiaba3l4cxxm7rdiqmhs9kyv6wbq";
      name = "qtcanvas3d-opensource-src-5.7.0.tar.xz";
    };
  };
  qtcharts = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtcharts-opensource-src-5.7.0.tar.xz";
      sha256 = "0hsj5m9in4w9wzyvbs76v7zc67n9ja641ljc5vgfpbn7fmrsij1b";
      name = "qtcharts-opensource-src-5.7.0.tar.xz";
    };
  };
  qtconnectivity = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtconnectivity-opensource-src-5.7.0.tar.xz";
      sha256 = "00r7lc1w3snfp2qfqmviqzv0cw16zd8m1sfpvxvpl65yqmzcli4q";
      name = "qtconnectivity-opensource-src-5.7.0.tar.xz";
    };
  };
  qtdatavis3d = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtdatavis3d-opensource-src-5.7.0.tar.xz";
      sha256 = "18p82vh5s9bdshmxxkh7r9482i5vaih8nfya9f81l8ff7lw7lpcs";
      name = "qtdatavis3d-opensource-src-5.7.0.tar.xz";
    };
  };
  qtdeclarative = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtdeclarative-opensource-src-5.7.0.tar.xz";
      sha256 = "1x7rij423g5chlfd2kix54f393vxwjvdfsn1c7sybqmfycwn5pl6";
      name = "qtdeclarative-opensource-src-5.7.0.tar.xz";
    };
  };
  qtdeclarative-render2d = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtdeclarative-render2d-opensource-src-5.7.0.tar.xz";
      sha256 = "1qf893i7z2iyjpqpaxfhji4cgzlmpgh0w3vdqarpn51vcn7jj4q6";
      name = "qtdeclarative-render2d-opensource-src-5.7.0.tar.xz";
    };
  };
  qtdoc = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtdoc-opensource-src-5.7.0.tar.xz";
      sha256 = "0d7c7137jvxlwl91c2hh33l4falmjvkmsy1f7lyi73x6nnqzdz8i";
      name = "qtdoc-opensource-src-5.7.0.tar.xz";
    };
  };
  qtgamepad = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtgamepad-opensource-src-5.7.0.tar.xz";
      sha256 = "0g36nlnnq19p9svl6pvklxybpwig7r7z4hw0d5dwc2id02ygg62q";
      name = "qtgamepad-opensource-src-5.7.0.tar.xz";
    };
  };
  qtgraphicaleffects = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtgraphicaleffects-opensource-src-5.7.0.tar.xz";
      sha256 = "1rwdjg5mk6xpadmxfq64xfp573zp5lrj9illb9105ra5wff565n8";
      name = "qtgraphicaleffects-opensource-src-5.7.0.tar.xz";
    };
  };
  qtimageformats = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtimageformats-opensource-src-5.7.0.tar.xz";
      sha256 = "1rb27x7i2pmvsck6wax2cg31gqpzaakciy45wm5l3lcl86j48czg";
      name = "qtimageformats-opensource-src-5.7.0.tar.xz";
    };
  };
  qtlocation = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtlocation-opensource-src-5.7.0.tar.xz";
      sha256 = "0rd898gndn41jrp78203lxd94ybfv693l0qg0myag4r46ikk69vh";
      name = "qtlocation-opensource-src-5.7.0.tar.xz";
    };
  };
  qtmacextras = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtmacextras-opensource-src-5.7.0.tar.xz";
      sha256 = "1p439sqnchrypggaqkfq3rvfk7xmvqgck4nhwv762jk3kgp48ccq";
      name = "qtmacextras-opensource-src-5.7.0.tar.xz";
    };
  };
  qtmultimedia = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtmultimedia-opensource-src-5.7.0.tar.xz";
      sha256 = "0ndmhiflmyr144nq8drd5njsdi282ixsm4730q5n0ji2v9dp1bh5";
      name = "qtmultimedia-opensource-src-5.7.0.tar.xz";
    };
  };
  qtpurchasing = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtpurchasing-opensource-src-5.7.0.tar.xz";
      sha256 = "1db44q3d02nhmrh0fd239n2nsm74myac8saa6jqx1pcap4y4llby";
      name = "qtpurchasing-opensource-src-5.7.0.tar.xz";
    };
  };
  qtquickcontrols2 = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtquickcontrols2-opensource-src-5.7.0.tar.xz";
      sha256 = "0i8h933vhvx1bmniqdx0idg6vk82w9byd3dq0bb2phwjg5vv1xb3";
      name = "qtquickcontrols2-opensource-src-5.7.0.tar.xz";
    };
  };
  qtquickcontrols = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtquickcontrols-opensource-src-5.7.0.tar.xz";
      sha256 = "0cpcrmz9n5b4bgmshmk093lirl9xwqb23inchnai1zqg21vrmqfq";
      name = "qtquickcontrols-opensource-src-5.7.0.tar.xz";
    };
  };
  qtscript = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtscript-opensource-src-5.7.0.tar.xz";
      sha256 = "0040890p5ilyrmcpndz1hhp08x2ms5gw4lp4n5iax2a957yy2i4w";
      name = "qtscript-opensource-src-5.7.0.tar.xz";
    };
  };
  qtscxml = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtscxml-opensource-src-5.7.0.tar.xz";
      sha256 = "1waidk96vp9510g94fry0sv1vm2lgzgpwybf6c2xybcsdkbi62rp";
      name = "qtscxml-opensource-src-5.7.0.tar.xz";
    };
  };
  qtsensors = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtsensors-opensource-src-5.7.0.tar.xz";
      sha256 = "1gii6wg2xd3bkb86y5hgpmwcpl04xav030zscpl6fhscl9kcqg98";
      name = "qtsensors-opensource-src-5.7.0.tar.xz";
    };
  };
  qtserialbus = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtserialbus-opensource-src-5.7.0.tar.xz";
      sha256 = "0f2xq6fm8lmvd88lc3l37kybqp4wqp71kdch14bwz79y7777lhrc";
      name = "qtserialbus-opensource-src-5.7.0.tar.xz";
    };
  };
  qtserialport = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtserialport-opensource-src-5.7.0.tar.xz";
      sha256 = "0rc2l14s59qskp16wqlkizfai32s41qlm7a86r3qahx28gc51qaw";
      name = "qtserialport-opensource-src-5.7.0.tar.xz";
    };
  };
  qtsvg = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtsvg-opensource-src-5.7.0.tar.xz";
      sha256 = "10fqrlqkiq83xhx79g8d2sjy7hjdnp28067z8f4byj7db81rzy51";
      name = "qtsvg-opensource-src-5.7.0.tar.xz";
    };
  };
  qttools = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qttools-opensource-src-5.7.0.tar.xz";
      sha256 = "004m9l7bgh7qnncbyl3d5fkggdrqx58ib21xv4hflvvarxrssibg";
      name = "qttools-opensource-src-5.7.0.tar.xz";
    };
  };
  qttranslations = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qttranslations-opensource-src-5.7.0.tar.xz";
      sha256 = "0vasg5ycg5rhj8ljk3aqg1sxfrlz3602n38fr14ip853yqld83ha";
      name = "qttranslations-opensource-src-5.7.0.tar.xz";
    };
  };
  qtvirtualkeyboard = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtvirtualkeyboard-opensource-src-5.7.0.tar.xz";
      sha256 = "0bzzci32f8ji94p2n6n16n838lrykyy3h822gfw77c93ivk3shyz";
      name = "qtvirtualkeyboard-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwayland = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwayland-opensource-src-5.7.0.tar.xz";
      sha256 = "04dynjcr6gxi3hcqdf688a4hkabi2l17slpcx9k0f3dxygwcgf96";
      name = "qtwayland-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwebchannel = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwebchannel-opensource-src-5.7.0.tar.xz";
      sha256 = "05lqfidlh1ahdd1j9y20p2037qbcq51zkdzj2m8fwhn7ghbwvd1s";
      name = "qtwebchannel-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwebengine = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwebengine-opensource-src-5.7.0.tar.xz";
      sha256 = "0pfwsqjh107jqdw1mzzrhn38jxl64d8lljk4586im2ndypzn4mwq";
      name = "qtwebengine-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwebsockets = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwebsockets-opensource-src-5.7.0.tar.xz";
      sha256 = "0hwb2l7iwf4wf7l95dli8j3b7h0nffp56skfg1x810kzj0df26vl";
      name = "qtwebsockets-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwebview = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwebview-opensource-src-5.7.0.tar.xz";
      sha256 = "1i2ikv1ah4g3rc1pivxiw77p0yj79lialqww91fj781g66pky6l0";
      name = "qtwebview-opensource-src-5.7.0.tar.xz";
    };
  };
  qtwinextras = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtwinextras-opensource-src-5.7.0.tar.xz";
      sha256 = "1fh7kqfwgwi9pcfg9b6hp2fpgvs938wl96ppqan79apxlhqy5awd";
      name = "qtwinextras-opensource-src-5.7.0.tar.xz";
    };
  };
  qtx11extras = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtx11extras-opensource-src-5.7.0.tar.xz";
      sha256 = "1yrkn8pqdbvbqykas3wx1vdfimhjkgx3s5jgdxib9dgmgyx6vjzw";
      name = "qtx11extras-opensource-src-5.7.0.tar.xz";
    };
  };
  qtxmlpatterns = {
    version = "5.7.0";
    src = fetchurl {
      url = "${mirror}/official_releases/qt/5.7/5.7.0/submodules/qtxmlpatterns-opensource-src-5.7.0.tar.xz";
      sha256 = "02z2qxamslg6sphnaykjcjfpypq4b69pb586s43vw4fplm72m21q";
      name = "qtxmlpatterns-opensource-src-5.7.0.tar.xz";
    };
  };
}
