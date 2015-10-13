# DO NOT EDIT! This file is generated automatically by fetchsrcs.sh
{ fetchurl, mirror }:

{
  attica = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/attica-5.15.0.tar.xz";
      sha256 = "0gddapcl2m5gds8f341z0954qlllx22xbd51649lri429aw2ijcl";
      name = "attica-5.15.0.tar.xz";
    };
  };
  baloo = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/baloo-5.15.0.tar.xz";
      sha256 = "10qwxljzhl8wagfmvdbrmqlzk68jkrp703d232fr7gvz3qrmdpbz";
      name = "baloo-5.15.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/bluez-qt-5.15.0.tar.xz";
      sha256 = "15k242ifj3mfy0g0v7h504zn07cvahc70whc6n9yr0091j1azf5f";
      name = "bluez-qt-5.15.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/extra-cmake-modules-5.15.0.tar.xz";
      sha256 = "1g02dcbx1r0n2skrhmc6d3pckqvbii7ai91chlkwcdd8vzd4lgcg";
      name = "extra-cmake-modules-5.15.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/frameworkintegration-5.15.0.tar.xz";
      sha256 = "06sacinx3g3hrs11v67k7j8ddp5swasjrw6x36ng3mr81i2ksyia";
      name = "frameworkintegration-5.15.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kactivities-5.15.0.tar.xz";
      sha256 = "0h9f78f8r5z5jarxph168h1m0zvz2zhd8iq6gc9sg09044xn1lnq";
      name = "kactivities-5.15.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kapidox-5.15.0.tar.xz";
      sha256 = "1342j7459rafz1ns0nnlh1i65c05cd6l3c4sh1j75qgl0pjnrvcq";
      name = "kapidox-5.15.0.tar.xz";
    };
  };
  karchive = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/karchive-5.15.0.tar.xz";
      sha256 = "1s5mggi0vydg9w589qk4fp4qbhj7h9wcczn6k7j41bcqdapxzdfh";
      name = "karchive-5.15.0.tar.xz";
    };
  };
  kauth = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kauth-5.15.0.tar.xz";
      sha256 = "1nhrfbfasmg8a9gj94ri5qcvrdhhb204miv3i5y59ma09hd1xag2";
      name = "kauth-5.15.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kbookmarks-5.15.0.tar.xz";
      sha256 = "1y21679a37lspwf02vy687k5najap18x7hxd8k8hssdivjvg43z8";
      name = "kbookmarks-5.15.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kcmutils-5.15.0.tar.xz";
      sha256 = "0syk030b89z90aa85d1mlag613yaajipgfxxfxnp3f488s54qn6z";
      name = "kcmutils-5.15.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kcodecs-5.15.0.tar.xz";
      sha256 = "1kz8vbxblzf0lxcn6c2433lhgi2iyvqsm65qxsvf5zgxckq5277p";
      name = "kcodecs-5.15.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kcompletion-5.15.0.tar.xz";
      sha256 = "1mq110fg30y3xdmjicckysz3k5ylz92hz609ffjnm2svk56w5cny";
      name = "kcompletion-5.15.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kconfig-5.15.0.tar.xz";
      sha256 = "083g4pr5sbqvpdn3ic3afbjzvczxl095rj0pi34g2b28anpwhjvn";
      name = "kconfig-5.15.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kconfigwidgets-5.15.0.tar.xz";
      sha256 = "0gkq7ifgyf7865ypxf4cwqkndn4qrp07k8wxp8fl0xa15d74nrj3";
      name = "kconfigwidgets-5.15.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kcoreaddons-5.15.0.tar.xz";
      sha256 = "1v06bblxrxcwj9sbsz7xvqq6yg231m939pms8w0bbmyidsq4vpdm";
      name = "kcoreaddons-5.15.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kcrash-5.15.0.tar.xz";
      sha256 = "1631wmg895bb4ls2mfxnlnffmzl1mjm82ad8fk361gv0s9g0xb3y";
      name = "kcrash-5.15.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdbusaddons-5.15.0.tar.xz";
      sha256 = "1w32ra4ifhb2k2k2j3dfqrrc65w0rsmj9yr34k0flqiqs0mq1pfx";
      name = "kdbusaddons-5.15.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdeclarative-5.15.0.tar.xz";
      sha256 = "06xv552v52zp9qb5v6w3cps9nm3wpacpjvm8s08zmij1y7by0z32";
      name = "kdeclarative-5.15.0.tar.xz";
    };
  };
  kded = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kded-5.15.0.tar.xz";
      sha256 = "144lfjx6gmbhqqwdv4ll1ab4rj3pcyn8bp9yp4snzh6v2a2hncwq";
      name = "kded-5.15.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/kdelibs4support-5.15.0.tar.xz";
      sha256 = "1091nc3rrcq360sillynvmxwvmd209cnlql6g9x249zdxjpv62qy";
      name = "kdelibs4support-5.15.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdesignerplugin-5.15.0.tar.xz";
      sha256 = "0my6x0fx72dk65z6lajn1faxifc622msvll6jab0rk50x8ws9dwq";
      name = "kdesignerplugin-5.15.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdesu-5.15.0.tar.xz";
      sha256 = "0cnqd0gm5xyqsqngl0x6rs0f01bilcfv8xx1ry9hfnqffv9amr9y";
      name = "kdesu-5.15.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdewebkit-5.15.0.tar.xz";
      sha256 = "1cgwhb5nr6g6y3azp2ii0hdjlvwacdr94ldlsirqmzl7rymkgkqa";
      name = "kdewebkit-5.15.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdnssd-5.15.0.tar.xz";
      sha256 = "1z5d26pmc9vmf30zz35kcl585fpjfrp8xf5r13lfwnnbfr6pnh0k";
      name = "kdnssd-5.15.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kdoctools-5.15.0.tar.xz";
      sha256 = "0vci37val64ixcz7zr99gzdqlb0ff04gdj2kad5dj32295iixhva";
      name = "kdoctools-5.15.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kemoticons-5.15.0.tar.xz";
      sha256 = "0a3izq6w3w37qd6b6w2g179w9nrh5pwh8hnc4iggyr2wwf2hfw9c";
      name = "kemoticons-5.15.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kfilemetadata-5.15.0.tar.xz";
      sha256 = "1y90azm27mnw2wfilwmg1gls21fpnd2nzvdl26vrhpsvnclf8rqn";
      name = "kfilemetadata-5.15.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kglobalaccel-5.15.0.tar.xz";
      sha256 = "1ii7bd1rf038zjimz7nd2snfi76drqdnyrkivwd6np4fdvcsyhjr";
      name = "kglobalaccel-5.15.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kguiaddons-5.15.0.tar.xz";
      sha256 = "0pfcns136i0ghk32gyr7nnq7wnk2j8rmcr3jr18f1y9pkk3ih6q8";
      name = "kguiaddons-5.15.0.tar.xz";
    };
  };
  khtml = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/khtml-5.15.0.tar.xz";
      sha256 = "01gx1qd7hhvyhzndin8kw9yg3jlz8rz7i8kxbl6wpab9sc270a70";
      name = "khtml-5.15.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/ki18n-5.15.0.tar.xz";
      sha256 = "0qy7nv4ssjbyskjhnx8sr6vg9jwg183f6zd759rzp56pz5j79qdd";
      name = "ki18n-5.15.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kiconthemes-5.15.0.tar.xz";
      sha256 = "0ab9iki3jl4izzjph9bps04w7grimyyaaxsna6j0dzg90izg1zg2";
      name = "kiconthemes-5.15.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kidletime-5.15.0.tar.xz";
      sha256 = "0gp6grv6a9zb14yfrznwn5ih1946v500zlj5g9s8f1xw5p0792i2";
      name = "kidletime-5.15.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kimageformats-5.15.0.tar.xz";
      sha256 = "0q66w91khj4xax4nzak5r9wmr0qny5cq7dapv11zdzn7rf90bpvv";
      name = "kimageformats-5.15.0.tar.xz";
    };
  };
  kinit = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kinit-5.15.0.tar.xz";
      sha256 = "0ccf2rg6m74xj7mq4i0fsl09l2wkwyhmlfp3lvrn4714w19bj5yf";
      name = "kinit-5.15.0.tar.xz";
    };
  };
  kio = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kio-5.15.0.tar.xz";
      sha256 = "0ld56arcjms5kiz9zj3g7hgd6xq05zg2bx0qpr4aaihl3hgp6888";
      name = "kio-5.15.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kitemmodels-5.15.0.tar.xz";
      sha256 = "112a8mdxabzv7lhpxfnnz2jrib972lz6ww7gd92lqziprz78fyga";
      name = "kitemmodels-5.15.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kitemviews-5.15.0.tar.xz";
      sha256 = "1112x7lf0wvwsizcr2ij0w463cssg0ahcav872g39gzirf67lqyi";
      name = "kitemviews-5.15.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kjobwidgets-5.15.0.tar.xz";
      sha256 = "12r3j1bwvmacj70dng4g5yrgjgj4v8nizk4yf22dfy858k8v8zda";
      name = "kjobwidgets-5.15.0.tar.xz";
    };
  };
  kjs = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/kjs-5.15.0.tar.xz";
      sha256 = "1aj9w8009q8bdq17ckjr1z219qy4wkjwc5xggl1879haqxn1pfg3";
      name = "kjs-5.15.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/kjsembed-5.15.0.tar.xz";
      sha256 = "099m6k6m6imy7jdia822i1g6c61gp955w21m4bb5nndwdy580mj4";
      name = "kjsembed-5.15.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/kmediaplayer-5.15.0.tar.xz";
      sha256 = "1rli98klmizwmmwwn6lcna7vxihd7b5yrvshisw6ivb21ygjgrxm";
      name = "kmediaplayer-5.15.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/knewstuff-5.15.0.tar.xz";
      sha256 = "0s8ha0qqy007kq1k55mii5msbqxnczb57xici3in1idxjd83fjnw";
      name = "knewstuff-5.15.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/knotifications-5.15.0.tar.xz";
      sha256 = "1189xx9a5i932lfyniqnz43gl3hhjlg962j996zy0g9yasc2r3cm";
      name = "knotifications-5.15.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/knotifyconfig-5.15.0.tar.xz";
      sha256 = "0b279z1qwfhj2mnpil0jd3xs8yn4i8mvib8dws6q4nygl941b8sa";
      name = "knotifyconfig-5.15.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kpackage-5.15.0.tar.xz";
      sha256 = "03zcnqly2pb67pza9xm9n0asjixqicxwj5vnv25yvki02cgwmvn3";
      name = "kpackage-5.15.0.tar.xz";
    };
  };
  kparts = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kparts-5.15.0.tar.xz";
      sha256 = "0pjfmb97387kvvn7c4xzmxdja2jghx946ima5g8jnfw0zacsd2mw";
      name = "kparts-5.15.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kpeople-5.15.0.tar.xz";
      sha256 = "11frmba6rqn2bmqp28wrwrqw8lpkdg27v5fa5lg47vrdp4ih0rgs";
      name = "kpeople-5.15.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kplotting-5.15.0.tar.xz";
      sha256 = "0wwqlza0qfd25p9d5gfrs0ymwzg5b0lnb4b8slfw2znazvi03krj";
      name = "kplotting-5.15.0.tar.xz";
    };
  };
  kpty = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kpty-5.15.0.tar.xz";
      sha256 = "03yl4kwhwma0nwbgww95z4853waxrq4xipy41k7224n3gvd62c30";
      name = "kpty-5.15.0.tar.xz";
    };
  };
  kross = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/kross-5.15.0.tar.xz";
      sha256 = "1mlvs0ra3ngrmrmqb4qjg3nkw5hqscdd1p3cdh94mpcwk330svq0";
      name = "kross-5.15.0.tar.xz";
    };
  };
  krunner = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/portingAids/krunner-5.15.0.tar.xz";
      sha256 = "0kyb135a45b9si4xh7pml7aiigs3j5077dgjfrghhz0ci3ibmn0v";
      name = "krunner-5.15.0.tar.xz";
    };
  };
  kservice = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kservice-5.15.0.tar.xz";
      sha256 = "13yfg99s7k7y2npj8jn12iikan95dsf8hdmqfjb59n5qg4a6h253";
      name = "kservice-5.15.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/ktexteditor-5.15.0.tar.xz";
      sha256 = "161kkssai0lwssy6l4mxgclx7229bgfkfgsf973i94p6hanaymb8";
      name = "ktexteditor-5.15.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/ktextwidgets-5.15.0.tar.xz";
      sha256 = "1r9drjjlag5v7y8inswbrj2fmkzkranrnzyrwl4bl7v0l1dir2l8";
      name = "ktextwidgets-5.15.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kunitconversion-5.15.0.tar.xz";
      sha256 = "1qbps67w3ii2797q967wvy56zclsm9l6vcrwnylx9rfqygcs5ixf";
      name = "kunitconversion-5.15.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kwallet-5.15.0.tar.xz";
      sha256 = "1b97v4vad7lzrjmf04zikm4q9czyzbzkk3vdhcd2mi47vizrj392";
      name = "kwallet-5.15.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kwidgetsaddons-5.15.0.tar.xz";
      sha256 = "1nbgsf5dfz0f12azw19ir7791y6ykkkj7y96ln0k81d3cbcgxq63";
      name = "kwidgetsaddons-5.15.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kwindowsystem-5.15.0.tar.xz";
      sha256 = "1x8pagby6j7k2ns3davbmyysggril0kp9ccn3326qm89l70zrf8x";
      name = "kwindowsystem-5.15.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kxmlgui-5.15.0.tar.xz";
      sha256 = "1d5mm2fkzk92q9gfh76a83mbzqw2pcagkg6s51i5ax3zqb7jnzdm";
      name = "kxmlgui-5.15.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/kxmlrpcclient-5.15.0.tar.xz";
      sha256 = "03ckqn33djzyg0ik9g1jk4dj33incsxwvvdc7g5k8wjgjcdkp433";
      name = "kxmlrpcclient-5.15.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/modemmanager-qt-5.15.0.tar.xz";
      sha256 = "1sxi32jxsz3d51nkcx7wxjyjvr2fg3qay3s3nzrpdzm0pa79drr9";
      name = "modemmanager-qt-5.15.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/networkmanager-qt-5.15.0.tar.xz";
      sha256 = "0l0396c9fgwxdv1h33p7y8w0ylvm4pa3a53yv7jckkc49nygk38p";
      name = "networkmanager-qt-5.15.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/plasma-framework-5.15.0.tar.xz";
      sha256 = "0v36i64jb3n6lq964417lzbdm6m57nvg83kjli4wqlc17dywjp8s";
      name = "plasma-framework-5.15.0.tar.xz";
    };
  };
  solid = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/solid-5.15.0.tar.xz";
      sha256 = "0118bynfqcgvg333ljbb80k7bkam6skc7vygwvy7fr7y4dzmlwfa";
      name = "solid-5.15.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/sonnet-5.15.0.tar.xz";
      sha256 = "18qs5szdyvjzwlbid62g3qs7cs4fdb46n25aw49saq7drf567gm0";
      name = "sonnet-5.15.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.15.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.15/threadweaver-5.15.0.tar.xz";
      sha256 = "19ha9r6wjm93w4kh5rjaal0r91vxhsr9q82dw5b9j927zrqwb7pq";
      name = "threadweaver-5.15.0.tar.xz";
    };
  };
}
