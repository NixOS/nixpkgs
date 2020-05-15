# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks
{ fetchurl, mirror }:

{
  attica = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/attica-5.68.0.tar.xz";
      sha256 = "9b4001a32831c9bae1d44161247acd5e6d3048ca2ece98c2c756c72a1464b9e9";
      name = "attica-5.68.0.tar.xz";
    };
  };
  baloo = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/baloo-5.68.0.tar.xz";
      sha256 = "4b599fb279ef92dc4f575847767c370f2633b27e884e372c3f7b92f08917865e";
      name = "baloo-5.68.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/bluez-qt-5.68.0.tar.xz";
      sha256 = "99889cac874820e83a32bee938b6cc8e25dca6a3013d4a589ac7b8f5d32b4224";
      name = "bluez-qt-5.68.0.tar.xz";
    };
  };
  breeze-icons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/breeze-icons-5.68.0.tar.xz";
      sha256 = "750fff6560abfa85a2243187d14f1b8f1d3d1c4097d84cbf8c58d2f48102fe8d";
      name = "breeze-icons-5.68.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/extra-cmake-modules-5.68.0.tar.xz";
      sha256 = "4d60869ca96a323b56f00b40c4728a70dfebe2132bbae040442a6a2ef90e2d6e";
      name = "extra-cmake-modules-5.68.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/frameworkintegration-5.68.0.tar.xz";
      sha256 = "5bb3c2e56b2c4c41d8a472363f80445fd3fc28656e6a3163d48ed826a133985a";
      name = "frameworkintegration-5.68.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kactivities-5.68.0.tar.xz";
      sha256 = "1853135feb6adfec252e6fab0b1472450422afd5998a9a31d942e8672fbe7111";
      name = "kactivities-5.68.0.tar.xz";
    };
  };
  kactivities-stats = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kactivities-stats-5.68.0.tar.xz";
      sha256 = "fb645db4685113dfd98834f48d8941529fee53d5e26ec5e36cfee8a9bfae97ae";
      name = "kactivities-stats-5.68.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kapidox-5.68.0.tar.xz";
      sha256 = "4f60582cb0771c38733989f192694636b1c93ecae290bfbe551030dd397e976e";
      name = "kapidox-5.68.0.tar.xz";
    };
  };
  karchive = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/karchive-5.68.0.tar.xz";
      sha256 = "518f07629d87e5778e1d8ce066f5590941472d9fffa7bd74819759be5c6edf0d";
      name = "karchive-5.68.0.tar.xz";
    };
  };
  kauth = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kauth-5.68.0.tar.xz";
      sha256 = "b9a7cd724709ea188852f7656fbeda2dc3cc40cc5d09573049c2680c0edbd41f";
      name = "kauth-5.68.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kbookmarks-5.68.0.tar.xz";
      sha256 = "80dc06188a5e1d960d46f527bd82d9b79df75a785164fa29a088a7b705abbf84";
      name = "kbookmarks-5.68.0.tar.xz";
    };
  };
  kcalendarcore = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcalendarcore-5.68.0.tar.xz";
      sha256 = "50ffbe4feb9a602c09e130d6f10f0f260fa7625bc266003697895e1d716d6ba9";
      name = "kcalendarcore-5.68.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcmutils-5.68.0.tar.xz";
      sha256 = "a688d54286fe11b23e11e2100536a513a332d2a7d784fcbebeaccbfb980d83d1";
      name = "kcmutils-5.68.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcodecs-5.68.0.tar.xz";
      sha256 = "5f1e6ae3a51ca817aa0a5082ce4ce5490cb527388ef1888a642fb374c5e2bb48";
      name = "kcodecs-5.68.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcompletion-5.68.0.tar.xz";
      sha256 = "642d68b4c472e11a8861a61238297633be288bfd72c13547707754f1ae2be33a";
      name = "kcompletion-5.68.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kconfig-5.68.0.tar.xz";
      sha256 = "c3bf138a7a4d002475f2483987baf40a61cda7d491c3cc292dd2c6da726ee898";
      name = "kconfig-5.68.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kconfigwidgets-5.68.0.tar.xz";
      sha256 = "f50421e9dbb6669e8d7c10605f7779ad03f30ea7c9c4451a70a7be66cd9df995";
      name = "kconfigwidgets-5.68.0.tar.xz";
    };
  };
  kcontacts = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcontacts-5.68.0.tar.xz";
      sha256 = "532f1e89c7412e971db8c431d627d38144470ddf5c978a7fa9348e418b6cd3c3";
      name = "kcontacts-5.68.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcoreaddons-5.68.0.tar.xz";
      sha256 = "c578ae30b4161e45e672d613d2d9c5575a849d21909d9817f90a441044df65d7";
      name = "kcoreaddons-5.68.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kcrash-5.68.0.tar.xz";
      sha256 = "60daf2cee87c652619b098b688edce6f993c7960783159cd8be9d9145df29f7f";
      name = "kcrash-5.68.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kdbusaddons-5.68.0.tar.xz";
      sha256 = "839fe42f9ac8df353f87245110fd7b515a8eb29f0840f54481bd89e5175bf1af";
      name = "kdbusaddons-5.68.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kdeclarative-5.68.0.tar.xz";
      sha256 = "96a032bcb360e0ffcfe51d4d2f6153786682c2f967592bffcf15b9e6cd4cd3ae";
      name = "kdeclarative-5.68.0.tar.xz";
    };
  };
  kded = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kded-5.68.0.tar.xz";
      sha256 = "b03afe48fbdbd7d92c46b3b60bdb4b825f77e1a9d00c16a5f236b24a0135e4b7";
      name = "kded-5.68.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kdelibs4support-5.68.0.tar.xz";
      sha256 = "2fca7bf9d31b081e7568631b6b6d2f7847068217261e47ef0dea106470c22df1";
      name = "kdelibs4support-5.68.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kdesignerplugin-5.68.0.tar.xz";
      sha256 = "ae433e0eeaf0007312b1f32fc4349cf26c34617a5a9951ae4155c5c4e4009b72";
      name = "kdesignerplugin-5.68.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kdesu-5.68.0.tar.xz";
      sha256 = "427ba50bcd14308980cbdfdc77a6b7419277942a42d83da72ff3afbc1ec78903";
      name = "kdesu-5.68.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kdewebkit-5.68.0.tar.xz";
      sha256 = "181b14bd80e9f34aa2f896d39aca5be91f65d65bfaaf47660e91fdd98b7f36a2";
      name = "kdewebkit-5.68.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kdnssd-5.68.0.tar.xz";
      sha256 = "3369da85c0088c375f2123a82132fb84490c46ebc8e9cd1253c795ef45fd4403";
      name = "kdnssd-5.68.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kdoctools-5.68.0.tar.xz";
      sha256 = "93f5bee9dfaacacacfbeb3e915b192b5e645c1d01057b0cea4081c9ae5285670";
      name = "kdoctools-5.68.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kemoticons-5.68.0.tar.xz";
      sha256 = "e03fe81ad34e107dc5fe61f9bf424ecef7716bf8a62f8abb78fd3f6bd6806f56";
      name = "kemoticons-5.68.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kfilemetadata-5.68.0.tar.xz";
      sha256 = "c2a8aee8243efa30fc921b7f50b390b47ee2cf83aa83b125a530a25de6d6fe21";
      name = "kfilemetadata-5.68.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kglobalaccel-5.68.0.tar.xz";
      sha256 = "2eb710a3f29cbc8b7875fb3e8315d7c8e3b5bb93867e0a34cd5cdbac690bcbbf";
      name = "kglobalaccel-5.68.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kguiaddons-5.68.0.tar.xz";
      sha256 = "cdbf694e92b47358c2e2c31917bf5f01382042c2cb99b65faf3bc00a0eb52c64";
      name = "kguiaddons-5.68.0.tar.xz";
    };
  };
  kholidays = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kholidays-5.68.0.tar.xz";
      sha256 = "067a544c22f5988cf959a475b66ed62e419b975b3ee22810667a076f3d50dbba";
      name = "kholidays-5.68.0.tar.xz";
    };
  };
  khtml = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/khtml-5.68.0.tar.xz";
      sha256 = "af97da0a5d877c928d98690c3629a8f9788b29b27f583c9e3e26144a6abb9dcc";
      name = "khtml-5.68.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/ki18n-5.68.0.tar.xz";
      sha256 = "2c59dd55d032c95710e338e376a31bf11d799bceba8ebfdb148c8b77067a1e92";
      name = "ki18n-5.68.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kiconthemes-5.68.0.tar.xz";
      sha256 = "ac3f322f2644dd0468cd2b07cc0c7f853f1ac4bc714fe532bbe92e88141f6729";
      name = "kiconthemes-5.68.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kidletime-5.68.0.tar.xz";
      sha256 = "cd6309d403ea36553abc99af4fa7e4ed3f8b3b2c55d14887ef09d68e5627b3e7";
      name = "kidletime-5.68.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kimageformats-5.68.0.tar.xz";
      sha256 = "498fab29d19f10f2c91c796134f959b2cf3ce8372087b5eeb62f07e62af85949";
      name = "kimageformats-5.68.0.tar.xz";
    };
  };
  kinit = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kinit-5.68.0.tar.xz";
      sha256 = "fa136996eaaa7d2adb5a341c2b7a1abe86d8139c6f18999e0b0dc0220e512559";
      name = "kinit-5.68.0.tar.xz";
    };
  };
  kio = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kio-5.68.0.tar.xz";
      sha256 = "9cc2fb2da84d6661a90eac81eb12c2e37921a5c34cbc1975f48d613e5a9d9eef";
      name = "kio-5.68.0.tar.xz";
    };
  };
  kirigami2 = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kirigami2-5.68.0.tar.xz";
      sha256 = "ad5f78afc916e9cb26f23918a6eb1983d4a57aa7e4f7314a8c23fb81e0fcaf4b";
      name = "kirigami2-5.68.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kitemmodels-5.68.0.tar.xz";
      sha256 = "4f435db4362832cf63e49896229affd07f125567931fc499751d37ac3bafb149";
      name = "kitemmodels-5.68.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kitemviews-5.68.0.tar.xz";
      sha256 = "5196885ac42347d67779df61a03d7f9c54f38053ff91348ef6fdc08439b4742f";
      name = "kitemviews-5.68.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kjobwidgets-5.68.0.tar.xz";
      sha256 = "a11ba51ed0ab330f9a921cf0a61e604c27d88c1c2ea477a875bc0a0cd228a292";
      name = "kjobwidgets-5.68.0.tar.xz";
    };
  };
  kjs = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kjs-5.68.0.tar.xz";
      sha256 = "18e3d7c667aec21e9e4d0d4730ad32a10475b7db5a574a674a8b90a6f9e0cd0e";
      name = "kjs-5.68.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kjsembed-5.68.0.tar.xz";
      sha256 = "e9b9ac63f06447ffc6870806eb1507f0281281bae907fdbae42ee87a2b926db2";
      name = "kjsembed-5.68.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kmediaplayer-5.68.0.tar.xz";
      sha256 = "aa07466ea27b2e042e03d76fe3a23c570ba6521f57a2a51dc0ddf32fc8276db0";
      name = "kmediaplayer-5.68.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/knewstuff-5.68.0.tar.xz";
      sha256 = "f7c13b133f8b87ceece2d33d3f69215912b3b8c1dbb92ac39a1a6a0a42b7c93a";
      name = "knewstuff-5.68.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/knotifications-5.68.0.tar.xz";
      sha256 = "646bd3bac073fbf4f19f9047360325c933751d605cf1311f4c922d7457fbda51";
      name = "knotifications-5.68.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/knotifyconfig-5.68.0.tar.xz";
      sha256 = "36c7c93964f2b9b584d73de1757f75d6ee8bb29ebe860e8fd6905354d2f10145";
      name = "knotifyconfig-5.68.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kpackage-5.68.0.tar.xz";
      sha256 = "49727d89f1ca7ee504397d6e8b5cd25c26cd0061596b26d8ab2b64e3987d2d16";
      name = "kpackage-5.68.0.tar.xz";
    };
  };
  kparts = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kparts-5.68.0.tar.xz";
      sha256 = "fd17d0b0ff41d66c122530bbd8d1187f3271382207f63237ce72147865bf6d29";
      name = "kparts-5.68.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kpeople-5.68.0.tar.xz";
      sha256 = "1cae86d527d650d9fa311f6007cc33b5dcd858bcfe4eb7cae65b5402205c4675";
      name = "kpeople-5.68.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kplotting-5.68.0.tar.xz";
      sha256 = "ccae7f90c016a1c517db820f352bb962f600678efdc4ac6b12e33d2c48f5c268";
      name = "kplotting-5.68.0.tar.xz";
    };
  };
  kpty = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kpty-5.68.0.tar.xz";
      sha256 = "35b838cff80311db52d83e1f61bc365277d54929742ee34265f36a12ce7689e3";
      name = "kpty-5.68.0.tar.xz";
    };
  };
  kquickcharts = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kquickcharts-5.68.0.tar.xz";
      sha256 = "2cfb78bc2a7659a8c4ca6b072ff586c44e6da64e10b84a0fb0c5e3f03c944628";
      name = "kquickcharts-5.68.0.tar.xz";
    };
  };
  kross = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/portingAids/kross-5.68.0.tar.xz";
      sha256 = "2f5a79a2097f84bfd2033ca183abdbf6626f6e5dc2c6f781c312f15c97dace33";
      name = "kross-5.68.0.tar.xz";
    };
  };
  krunner = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/krunner-5.68.0.tar.xz";
      sha256 = "4575ae1d658d32c15f9d57dc30616073e9d143d1a7f9632556906ef10e82e3b8";
      name = "krunner-5.68.0.tar.xz";
    };
  };
  kservice = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kservice-5.68.0.tar.xz";
      sha256 = "c774ce1738081c17e6e105e506aa89c22a9db07e73972d4b18ce733ec8ad0a8a";
      name = "kservice-5.68.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/ktexteditor-5.68.0.tar.xz";
      sha256 = "dad373d4c136d113cca1ee6d700753563b7348813ff3229db670eedc63980cd6";
      name = "ktexteditor-5.68.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/ktextwidgets-5.68.0.tar.xz";
      sha256 = "23b354469afed21c840ca36e2bb5b2b383ed5c4ec3690bb009e273c39fbe00c0";
      name = "ktextwidgets-5.68.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kunitconversion-5.68.0.tar.xz";
      sha256 = "39ec06e2439306ce5b5efe5fe972d201e8c8e5fda634652cdc01c58427574adb";
      name = "kunitconversion-5.68.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kwallet-5.68.0.tar.xz";
      sha256 = "7524eeffdde3166df182f0dbf0f3f461905547bfd7a06387c7c503cd1ab75ecf";
      name = "kwallet-5.68.0.tar.xz";
    };
  };
  kwayland = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kwayland-5.68.0.tar.xz";
      sha256 = "7c99bfac8f4bff457a5384c846be776c385649ced76be0f48699c6e12de24e7c";
      name = "kwayland-5.68.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kwidgetsaddons-5.68.0.tar.xz";
      sha256 = "b4ff96b4ec6365e5f9e4da5e651da99be491799a4e6cfd982d0838dda39844ac";
      name = "kwidgetsaddons-5.68.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kwindowsystem-5.68.0.tar.xz";
      sha256 = "859c930a04c2588f792bfb9a28ed40b226db632b15c2851b186301b70d4c825a";
      name = "kwindowsystem-5.68.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kxmlgui-5.68.0.tar.xz";
      sha256 = "6310e9a725a982d3b70672367c5858727437fe08c8e409458e48b6015c7bf10e";
      name = "kxmlgui-5.68.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/kxmlrpcclient-5.68.0.tar.xz";
      sha256 = "e49f2ab649aafb292e01dacefb7b6f28fc596606764bef61e7ce622b67241324";
      name = "kxmlrpcclient-5.68.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/modemmanager-qt-5.68.0.tar.xz";
      sha256 = "9c0febf18a04b69e47cffdb4563390a79a4a673da856502cbf50d5c7707670ec";
      name = "modemmanager-qt-5.68.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/networkmanager-qt-5.68.0.tar.xz";
      sha256 = "6a9bea5e6d58f5322848114e4e827edadee6b5a890a3549446ff23a568325e2c";
      name = "networkmanager-qt-5.68.0.tar.xz";
    };
  };
  oxygen-icons5 = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/oxygen-icons5-5.68.0.tar.xz";
      sha256 = "75a8113e567d8cbba57bda3c8829d116d58ebf6bc5ace88aed7700b28a00c463";
      name = "oxygen-icons5-5.68.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/plasma-framework-5.68.0.tar.xz";
      sha256 = "d27c7a62231784ecad1246f8a81b02fd6db2e9818244a06650fd6c972a69ea74";
      name = "plasma-framework-5.68.0.tar.xz";
    };
  };
  prison = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/prison-5.68.0.tar.xz";
      sha256 = "22e2b8e9ca06e4fb7ab91afeddbaebe6e2b6792bbcd5ba6c440c6fad0df176b7";
      name = "prison-5.68.0.tar.xz";
    };
  };
  purpose = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/purpose-5.68.0.tar.xz";
      sha256 = "c8c8f8244b568e52b4c02b89b71611bb8ba7cd07173645caa022b4bd90b41ab0";
      name = "purpose-5.68.0.tar.xz";
    };
  };
  qqc2-desktop-style = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/qqc2-desktop-style-5.68.0.tar.xz";
      sha256 = "0f522861e5757de6a1205c86a2e5f8d2a7375c96eac1ece95d03a35858dc7b03";
      name = "qqc2-desktop-style-5.68.0.tar.xz";
    };
  };
  solid = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/solid-5.68.0.tar.xz";
      sha256 = "472c1934b3c9cf917f28ac0e5b0864de442b96852744c301d88d8ab7269d74c3";
      name = "solid-5.68.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/sonnet-5.68.0.tar.xz";
      sha256 = "079c4f5fcb9fe670e1242b18648e178aaa01eb81dbdfc881805eea1ec585bd67";
      name = "sonnet-5.68.0.tar.xz";
    };
  };
  syndication = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/syndication-5.68.0.tar.xz";
      sha256 = "0715fc1b7312b5081521b781d0878d88cc70dcb77272ee173cecca03cc221fd3";
      name = "syndication-5.68.0.tar.xz";
    };
  };
  syntax-highlighting = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/syntax-highlighting-5.68.0.tar.xz";
      sha256 = "a857c743aa60b21eea7e4b986e8b195882aa2c18358412e767e68d93ce35e134";
      name = "syntax-highlighting-5.68.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.68.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.68/threadweaver-5.68.0.tar.xz";
      sha256 = "e28c0bfff375b3e1e9e4eec72f0a804f3f41c4ec5fd59af9b951708d229eff64";
      name = "threadweaver-5.68.0.tar.xz";
    };
  };
}
