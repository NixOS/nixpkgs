# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks
{ fetchurl, mirror }:

{
  attica = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/attica-5.73.0.tar.xz";
      sha256 = "011240a6ff59e2b39bcf6d4ba6128e6e60c6318c185e7316a71cfec28e69c69a";
      name = "attica-5.73.0.tar.xz";
    };
  };
  baloo = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/baloo-5.73.0.tar.xz";
      sha256 = "887077ae3e090d673d2ffe7eb869a0ab6f5d14e9dae2dccd619e4689699a2dfe";
      name = "baloo-5.73.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/bluez-qt-5.73.0.tar.xz";
      sha256 = "70264edb82b2627c0ec3740374b90b8402e0f432fe4a10650fa3d22191d8cfd4";
      name = "bluez-qt-5.73.0.tar.xz";
    };
  };
  breeze-icons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/breeze-icons-5.73.0.tar.xz";
      sha256 = "b6caff26f69008a3e0d53ae5fcfcf070b70ad1b17d407daecbbabeb6a606a08b";
      name = "breeze-icons-5.73.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/extra-cmake-modules-5.73.0.tar.xz";
      sha256 = "c5e3ef0253f7d5ab3adf9185950e34fd620a3d5baaf3bcc15892f971fc3274c4";
      name = "extra-cmake-modules-5.73.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/frameworkintegration-5.73.0.tar.xz";
      sha256 = "21ef7f1a6d48f9fb14ccac9bc37e803c92cf83c9e235a5ca8bd7eb08fd0a6fb3";
      name = "frameworkintegration-5.73.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kactivities-5.73.0.tar.xz";
      sha256 = "5098f2535175ac12da91568ca554e3f5d970ae05415da1a8ba17305cb8ac3a1a";
      name = "kactivities-5.73.0.tar.xz";
    };
  };
  kactivities-stats = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kactivities-stats-5.73.0.tar.xz";
      sha256 = "df4b00c52e83608b2dd7345cd220143e07b65cb431cead5e9abb1e4ffd6ecd5a";
      name = "kactivities-stats-5.73.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kapidox-5.73.0.tar.xz";
      sha256 = "b49ff6673906817ed95a3de56535594de02a9f95bcb2726abe52d0c0e0161be5";
      name = "kapidox-5.73.0.tar.xz";
    };
  };
  karchive = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/karchive-5.73.0.tar.xz";
      sha256 = "25481ebbba8f58d9ab45bde804ab0d873c45550b482e27e7856b362cd9aa434f";
      name = "karchive-5.73.0.tar.xz";
    };
  };
  kauth = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kauth-5.73.0.tar.xz";
      sha256 = "e334705bfc3f81c5e2f66315d40badd26d88426128432788f790ebefce1694d9";
      name = "kauth-5.73.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kbookmarks-5.73.0.tar.xz";
      sha256 = "b925ec1b8a1b4a2b7f2526fdbc7761de065b3c9573e41ac274773ed1b576aa51";
      name = "kbookmarks-5.73.0.tar.xz";
    };
  };
  kcalendarcore = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcalendarcore-5.73.0.tar.xz";
      sha256 = "e3486b41b833c0ba72f839d8a61bdffaf9b3ece3da20f478c2981b3296e7b713";
      name = "kcalendarcore-5.73.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcmutils-5.73.0.tar.xz";
      sha256 = "b28bf672bbe21e8d1b4e6ea924c1bb318c81c43dcbb86bebb3f5775e18945ca9";
      name = "kcmutils-5.73.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcodecs-5.73.0.tar.xz";
      sha256 = "3bcb22b4f3b2f164759ab912d117c3b4b50695ae38d524f2cfb79a29488cce67";
      name = "kcodecs-5.73.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcompletion-5.73.0.tar.xz";
      sha256 = "72b0650e5ae9f30ad4ec30b55e660c826d93edfda0ef4f9436f226cbb8a9705a";
      name = "kcompletion-5.73.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kconfig-5.73.0.tar.xz";
      sha256 = "6046bbb8da5f3261aac7f868bfa8a8ce1015a3a8257fe0b2d37dce9e2bc3952e";
      name = "kconfig-5.73.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kconfigwidgets-5.73.0.tar.xz";
      sha256 = "ed8a0a8158f895aebd46c4a725f77178d942cd9476a864a615a9df343da51f8e";
      name = "kconfigwidgets-5.73.0.tar.xz";
    };
  };
  kcontacts = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcontacts-5.73.0.tar.xz";
      sha256 = "4351bf80f5a5417ba7e99fe557a851d1c7173fd7511fc1426375c66692e748bb";
      name = "kcontacts-5.73.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcoreaddons-5.73.0.tar.xz";
      sha256 = "24a7713eaef2f40e648a586e22b030192321f9fecdbae77013b00446fa0d6d51";
      name = "kcoreaddons-5.73.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kcrash-5.73.0.tar.xz";
      sha256 = "49b6f4d6109ddf3a6b93f833f59483e5a1a748e4b829c4739fdaaaef59c9b583";
      name = "kcrash-5.73.0.tar.xz";
    };
  };
  kdav = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdav-5.73.0.tar.xz";
      sha256 = "03c8af96e7bb1b1d2d633e54c6362c7c2de078b8aba5654042b7a11d968efa31";
      name = "kdav-5.73.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdbusaddons-5.73.0.tar.xz";
      sha256 = "f7f7e57b4d4650cf90a191b08b1fe874d0005c34163b9177dcc787415841e8ba";
      name = "kdbusaddons-5.73.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdeclarative-5.73.0.tar.xz";
      sha256 = "713ae2ea41e1bac8f6d47cffa376d62c7805eb3e4cc41c3168c1f1b2ca70a598";
      name = "kdeclarative-5.73.0.tar.xz";
    };
  };
  kded = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kded-5.73.0.tar.xz";
      sha256 = "f21647a5f35eebaa9bf12b5d5da25c24611c1971f94f27c510d22a48c79b0895";
      name = "kded-5.73.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kdelibs4support-5.73.0.tar.xz";
      sha256 = "ca6f58c97b331d130a555b950c36cd7f625ca923fd185b0f73e20ac5b98c5d9b";
      name = "kdelibs4support-5.73.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kdesignerplugin-5.73.0.tar.xz";
      sha256 = "379db9fd0ec135706630dbd54e1b446e51dd3b64189754c281993d761c1d20b2";
      name = "kdesignerplugin-5.73.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdesu-5.73.0.tar.xz";
      sha256 = "4dd07697decad6a544025178732bd279ef64766e1929a2135f6de58b1092944d";
      name = "kdesu-5.73.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kdewebkit-5.73.0.tar.xz";
      sha256 = "d8208c4f7a98b6749c793649e2e5fbe3939e253289a9f6b74b559f6546b34b0b";
      name = "kdewebkit-5.73.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdnssd-5.73.0.tar.xz";
      sha256 = "bee7f654f704d928b1219b75a289042474c1450e9f8acb02a905a4a177bc5b7d";
      name = "kdnssd-5.73.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kdoctools-5.73.0.tar.xz";
      sha256 = "d8dd74776d47e009d4a204d69a78428603ca99317095d7b7edca49c3d93b1b5d";
      name = "kdoctools-5.73.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kemoticons-5.73.0.tar.xz";
      sha256 = "0c0a26b029a8fd3d8db97bac931feb7834912aa2f7680660e98d91e868d10778";
      name = "kemoticons-5.73.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kfilemetadata-5.73.0.tar.xz";
      sha256 = "1ae217aab920741e445211e20b1b60dfcf80f4a6d1864aa63321dac7c3802894";
      name = "kfilemetadata-5.73.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kglobalaccel-5.73.0.tar.xz";
      sha256 = "0062db9adde4dab0be6b64430010c0a5653355d0d1680abc9ec8e71988ff871f";
      name = "kglobalaccel-5.73.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kguiaddons-5.73.0.tar.xz";
      sha256 = "45b4c5e0195abd79930635bbf20886b15b1b68b13fe4c56068579b91ef147350";
      name = "kguiaddons-5.73.0.tar.xz";
    };
  };
  kholidays = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kholidays-5.73.0.tar.xz";
      sha256 = "b0ae4b77aa7c183959bc18baa09a1a4f7208fcad2a238c1590377bf6cf8b68ab";
      name = "kholidays-5.73.0.tar.xz";
    };
  };
  khtml = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/khtml-5.73.0.tar.xz";
      sha256 = "378a5aaa6c796d313a63b4cf1365cdd980f2bc21e9033354f2f1317d1db9c262";
      name = "khtml-5.73.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/ki18n-5.73.0.tar.xz";
      sha256 = "97eef22d6cdd65c57edfe54fa9760a69005e15b7d8f4270f6185916c33e14689";
      name = "ki18n-5.73.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kiconthemes-5.73.0.tar.xz";
      sha256 = "4490109a0a42675e4cd3497433e10fd4be24ef644a283edf46b308314d130356";
      name = "kiconthemes-5.73.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kidletime-5.73.0.tar.xz";
      sha256 = "52a8af3f061101c406a592ec277a2c84846e3910af1d3dbfc3e15beb9cfd24a2";
      name = "kidletime-5.73.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kimageformats-5.73.0.tar.xz";
      sha256 = "473d0f67d5357bbf08aa4f4504ceaceabc720b1f5433b456ddc5f8ad0d7e3b8b";
      name = "kimageformats-5.73.0.tar.xz";
    };
  };
  kinit = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kinit-5.73.0.tar.xz";
      sha256 = "0c61e90f3db83b4dc5f2438cf7880a02b600a5739cb05e5ee372aeff98b8b770";
      name = "kinit-5.73.0.tar.xz";
    };
  };
  kio = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kio-5.73.0.tar.xz";
      sha256 = "05da159e6cf5ef9aa4dd7ede86ce28a5581624a1b3f0b4718c5b7e30c4aa2a66";
      name = "kio-5.73.0.tar.xz";
    };
  };
  kirigami2 = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kirigami2-5.73.0.tar.xz";
      sha256 = "9b2a097071f77804f6f2f2a478e5db602c8b5fee00de34fc44842f31223401bb";
      name = "kirigami2-5.73.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kitemmodels-5.73.0.tar.xz";
      sha256 = "6569e289ac9263d87ef6641fe2f3914b9ace6814832ac9c61825b1c6805ae371";
      name = "kitemmodels-5.73.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kitemviews-5.73.0.tar.xz";
      sha256 = "ec29707d789bee58c47ee538319560a168642f69e96cacb78818825e47177727";
      name = "kitemviews-5.73.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kjobwidgets-5.73.0.tar.xz";
      sha256 = "61d105c8f17dcfb85ad6c1e3bd2423ebeb430b9c290d193229bc953ac174f2bf";
      name = "kjobwidgets-5.73.0.tar.xz";
    };
  };
  kjs = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kjs-5.73.0.tar.xz";
      sha256 = "97b52557212a33d59a4b3a8c34ea8a94cd5f840fb0798e770164d3cb1e755be5";
      name = "kjs-5.73.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kjsembed-5.73.0.tar.xz";
      sha256 = "cc9896930c01a6bdbfaddada9516380c9a54e5d719836f1788d8e3a74108e1d3";
      name = "kjsembed-5.73.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kmediaplayer-5.73.0.tar.xz";
      sha256 = "69aa3bbedfc8b9a0dd9f4ac260cded9d7b5894477bf4b5b09065d0aae8e44ab2";
      name = "kmediaplayer-5.73.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/knewstuff-5.73.0.tar.xz";
      sha256 = "7669e62973f7e228975a07f15bb1c7f716edd81ce82d5f578a80b1f501abda1e";
      name = "knewstuff-5.73.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/knotifications-5.73.0.tar.xz";
      sha256 = "c8e9f36716db33baca93a0386d3bb6426408eee3843eb5854bdd8ad7579f372c";
      name = "knotifications-5.73.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/knotifyconfig-5.73.0.tar.xz";
      sha256 = "641a167a58856e99036d44b3e7472b44cdfbbf68e5d75b9af988d0b71dc10af4";
      name = "knotifyconfig-5.73.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kpackage-5.73.0.tar.xz";
      sha256 = "480b1e11733fe272d1a5680afea39bcc940f01bd3d1267be0981e3c92e098c4f";
      name = "kpackage-5.73.0.tar.xz";
    };
  };
  kparts = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kparts-5.73.0.tar.xz";
      sha256 = "5546d2a474c80a601ba013642775682b087d086bd26d0b0d025b68d680c98bf2";
      name = "kparts-5.73.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kpeople-5.73.0.tar.xz";
      sha256 = "9e0d3119c168f7843251c808cc149de15c1fd692062f431972023fdaa84d21c4";
      name = "kpeople-5.73.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kplotting-5.73.0.tar.xz";
      sha256 = "b5055ed9a3149c059623d88875816e9fac8d6d25d29fdfd48e0d8a16dfe01b14";
      name = "kplotting-5.73.0.tar.xz";
    };
  };
  kpty = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kpty-5.73.0.tar.xz";
      sha256 = "d3bf99062589dbd1dbe302c8ed2528845f245e7f0f17ca865cdd100f7589ce9c";
      name = "kpty-5.73.0.tar.xz";
    };
  };
  kquickcharts = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kquickcharts-5.73.0.tar.xz";
      sha256 = "e37e13a5d907d872679eab38ba8e983b2fb98a11e07a3c15d32cfaad09075cfe";
      name = "kquickcharts-5.73.0.tar.xz";
    };
  };
  kross = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kross-5.73.0.tar.xz";
      sha256 = "aa27b434da981f64c40985a61ee041417667844c6077c9fb52456635be67546e";
      name = "kross-5.73.0.tar.xz";
    };
  };
  krunner = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/krunner-5.73.0.tar.xz";
      sha256 = "b4e8427083b6546327eeb36b05a7e438e58f922d4cc5ae0c24cd8241924e9e09";
      name = "krunner-5.73.0.tar.xz";
    };
  };
  kservice = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kservice-5.73.0.tar.xz";
      sha256 = "a64bf7543870240f0d8f8c2bcf43759d98962ba94a4ed34bd23232df25bb408b";
      name = "kservice-5.73.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/ktexteditor-5.73.0.tar.xz";
      sha256 = "032b3ac31aa099ed67471f78401d13cf318646b0b9b5e20bb94796ac3ed6cf18";
      name = "ktexteditor-5.73.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/ktextwidgets-5.73.0.tar.xz";
      sha256 = "2a8b086fce8136b5b4af4a28b417343fb66148c1961e5d65bf40ccae2d4386e5";
      name = "ktextwidgets-5.73.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kunitconversion-5.73.0.tar.xz";
      sha256 = "97d008e8bdb2d1f89d2093294a8be0b13b0e0160658fa7d3de6c99a5fd5e2935";
      name = "kunitconversion-5.73.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kwallet-5.73.0.tar.xz";
      sha256 = "4a9c8a538054fc51b30679d5180d09bb6d12a833f595a8d6875b6d4c29074de1";
      name = "kwallet-5.73.0.tar.xz";
    };
  };
  kwayland = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kwayland-5.73.0.tar.xz";
      sha256 = "ee34a490a7bbc5e83eb36a6ac70492a76cb054d3077d0a8db216fd8b07f27bfe";
      name = "kwayland-5.73.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kwidgetsaddons-5.73.0.tar.xz";
      sha256 = "0722d853747b85ca7d46f278dc99c28b872185406b97b811523c1aa9b5e75eb6";
      name = "kwidgetsaddons-5.73.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kwindowsystem-5.73.0.tar.xz";
      sha256 = "0e27ad2cd5e4699efdc02daec181b4ffb0b9e31ec4c96f0f67899804aebbcde8";
      name = "kwindowsystem-5.73.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/kxmlgui-5.73.0.tar.xz";
      sha256 = "093131f5f51497ec61e99bd3e19de9421643d3f6ddf0099a823a3d624596ebcb";
      name = "kxmlgui-5.73.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/portingAids/kxmlrpcclient-5.73.0.tar.xz";
      sha256 = "c0d089c389f59bb7cb6fba629f3e122e70fda19a69f419ff8bd1d9fcee95a047";
      name = "kxmlrpcclient-5.73.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/modemmanager-qt-5.73.0.tar.xz";
      sha256 = "87f3864b2b53b4e309bca1feefa613455f60e4699969a569694f6813447e1fcd";
      name = "modemmanager-qt-5.73.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/networkmanager-qt-5.73.0.tar.xz";
      sha256 = "b909feafc0a9a18b59744e0f1973c5357f67bbd50b59afa82cf55955dae7d41f";
      name = "networkmanager-qt-5.73.0.tar.xz";
    };
  };
  oxygen-icons5 = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/oxygen-icons5-5.73.0.tar.xz";
      sha256 = "662cd9644e393c69dccb538cdd4280253be812f80704c992ada228c0c32c2bbc";
      name = "oxygen-icons5-5.73.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/plasma-framework-5.73.0.tar.xz";
      sha256 = "e5415143f0a08cd75cf758b0692021d2a2febdcb1364e2aa1e5c8fbeee148c93";
      name = "plasma-framework-5.73.0.tar.xz";
    };
  };
  prison = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/prison-5.73.0.tar.xz";
      sha256 = "a2b135ffdf1af240366f3fb077c02c02094fb1706c6e84fab5186802544a5b87";
      name = "prison-5.73.0.tar.xz";
    };
  };
  purpose = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/purpose-5.73.0.tar.xz";
      sha256 = "6f4d440cb708b636430e3206f879ca5c2e6cdfcf62f92ce173d43e291fbeed32";
      name = "purpose-5.73.0.tar.xz";
    };
  };
  qqc2-desktop-style = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/qqc2-desktop-style-5.73.0.tar.xz";
      sha256 = "290b3637be0c3740e92cdbb1421aef8bf1a8df36218f9d7d120e8422d14c3fdd";
      name = "qqc2-desktop-style-5.73.0.tar.xz";
    };
  };
  solid = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/solid-5.73.0.tar.xz";
      sha256 = "7366b64438a1ca7a42126e67d352e371227b46418ce961321d358f2eb90c0933";
      name = "solid-5.73.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/sonnet-5.73.0.tar.xz";
      sha256 = "009f76fc4317e407d30c4e162a807d620a95217f5db271a14b1f9fc4339d232c";
      name = "sonnet-5.73.0.tar.xz";
    };
  };
  syndication = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/syndication-5.73.0.tar.xz";
      sha256 = "2a65972ef5183edb0bd8b3804dae129ae8f4a4469287711e77fc636e90b8a954";
      name = "syndication-5.73.0.tar.xz";
    };
  };
  syntax-highlighting = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/syntax-highlighting-5.73.0.tar.xz";
      sha256 = "51ed4a68ba42d0dc88d91a0c11ac55ada199b7e93b0ff74b80b5e9304fe8901b";
      name = "syntax-highlighting-5.73.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.73.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.73/threadweaver-5.73.0.tar.xz";
      sha256 = "7e1152a1cf73f841c3be5d73cb0d5e6e29ec700be859c94275c5c00e49488d38";
      name = "threadweaver-5.73.0.tar.xz";
    };
  };
}
