# DO NOT EDIT! This file is generated automatically.
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks
{ fetchurl, mirror }:

{
  attica = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/attica-5.71.0.tar.xz";
      sha256 = "9e24fd7f58c66879a05e056b781637196eea69d3276ed470643c505f9fd46d3d";
      name = "attica-5.71.0.tar.xz";
    };
  };
  baloo = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/baloo-5.71.0.tar.xz";
      sha256 = "23378213d00ecf1f26eeb417987984f5a63bbd643359403dfd20638cbc1ec84b";
      name = "baloo-5.71.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/bluez-qt-5.71.0.tar.xz";
      sha256 = "7014e946f16db62218fe8e9af808999922d447034355f17b9e09b31321e53bad";
      name = "bluez-qt-5.71.0.tar.xz";
    };
  };
  breeze-icons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/breeze-icons-5.71.0.tar.xz";
      sha256 = "72217c46e071b204a80ff8064b1b7319c7a7f9f0b08e69d8add2065e5d301155";
      name = "breeze-icons-5.71.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/extra-cmake-modules-5.71.0.tar.xz";
      sha256 = "64f41c0b4b3164c7be8fcab5c0181253d97d1e9d62455fd540cb463afd051878";
      name = "extra-cmake-modules-5.71.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/frameworkintegration-5.71.0.tar.xz";
      sha256 = "f5ba2d5c363dcb09177424b82d9a59ce0f0a6b2dea372799dcba000452764961";
      name = "frameworkintegration-5.71.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kactivities-5.71.0.tar.xz";
      sha256 = "b4e63fec6532e4bdc41470985cea46b0a88c1b2298b80286cbf0ed2d2139b66f";
      name = "kactivities-5.71.0.tar.xz";
    };
  };
  kactivities-stats = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kactivities-stats-5.71.0.tar.xz";
      sha256 = "79fe4f674d7bae457ce6af0357104a8691f5822963b0ef1f99cd5a43e3666978";
      name = "kactivities-stats-5.71.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kapidox-5.71.0.tar.xz";
      sha256 = "da75660fc2808f38441ec0f59d3c58ce29fcfdcea29e251308a11a92546f1ed5";
      name = "kapidox-5.71.0.tar.xz";
    };
  };
  karchive = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/karchive-5.71.0.tar.xz";
      sha256 = "cc81e856365dec2bcf3ec78aa01d42347ca390a2311ea12050f309dfbdb09624";
      name = "karchive-5.71.0.tar.xz";
    };
  };
  kauth = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kauth-5.71.0.tar.xz";
      sha256 = "a0de83bd662e20253011216ab8cba597f8db7429f8706237e7307580125025b5";
      name = "kauth-5.71.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kbookmarks-5.71.0.tar.xz";
      sha256 = "e00db1e62a769863a1bf90bb508f108f2740298aa40173cad34ef34a1c23a01a";
      name = "kbookmarks-5.71.0.tar.xz";
    };
  };
  kcalendarcore = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcalendarcore-5.71.0.tar.xz";
      sha256 = "d5138db971f6be606be8ae7d761bad778af3cacada8e85fb2f469190c347cd94";
      name = "kcalendarcore-5.71.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcmutils-5.71.0.tar.xz";
      sha256 = "27743a81e9aa48baac12bb844e48d3098250699122ed6040b1e3c50a5e8f276d";
      name = "kcmutils-5.71.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcodecs-5.71.0.tar.xz";
      sha256 = "3392c4df652e3a44a2b941ccb419dee9521642e503104de403ec1c6be9f43a28";
      name = "kcodecs-5.71.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcompletion-5.71.0.tar.xz";
      sha256 = "bf0b6ce1ee133900f169662dbd35da6f766d3e4e02c0c102a9402e20450a22a4";
      name = "kcompletion-5.71.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kconfig-5.71.0.tar.xz";
      sha256 = "618ff0d168abf8fb73dc83431b9a76f7859d522bea100ff07c7e1632e129e3f4";
      name = "kconfig-5.71.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kconfigwidgets-5.71.0.tar.xz";
      sha256 = "5778523c49a5294e9376ce8ee6db1a51ffaa506418a19e8632f73287a596276f";
      name = "kconfigwidgets-5.71.0.tar.xz";
    };
  };
  kcontacts = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcontacts-5.71.0.tar.xz";
      sha256 = "57f511a624406b27a7de25c83deb4104c95e851f9fda4f6d94450155ab08f4bd";
      name = "kcontacts-5.71.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcoreaddons-5.71.0.tar.xz";
      sha256 = "e95008b032e299cf47f596739d9236701e2f55e507734f33b8ea497882fd130b";
      name = "kcoreaddons-5.71.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kcrash-5.71.0.tar.xz";
      sha256 = "526242aa9fde7cff11ecaa88bf75d6fbbfc412f46bf19a7a9e185f2adb616005";
      name = "kcrash-5.71.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kdbusaddons-5.71.0.tar.xz";
      sha256 = "b441f525248d9d675333cebedf97ee0232a3a9b7aa9aff84d825dfcdb3bcd23c";
      name = "kdbusaddons-5.71.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kdeclarative-5.71.0.tar.xz";
      sha256 = "ace0e52f561a9cfba1de4b77144a0a68037a1229530fb39070dc837da80ac8f8";
      name = "kdeclarative-5.71.0.tar.xz";
    };
  };
  kded = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kded-5.71.0.tar.xz";
      sha256 = "404c8caae0f4abe2ef85c2e82b5db2b14ae4b607fa30e4f16d15dad53c269fcc";
      name = "kded-5.71.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kdelibs4support-5.71.0.tar.xz";
      sha256 = "1110ed68a29e38059d195817735d58df45e59b57fa9ac48ef2036c1037a23fb7";
      name = "kdelibs4support-5.71.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kdesignerplugin-5.71.0.tar.xz";
      sha256 = "e77a96c2a6cd518f3040e9366f013f0128200791b6c93c3c5b2310af16fb040b";
      name = "kdesignerplugin-5.71.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kdesu-5.71.0.tar.xz";
      sha256 = "b183e67c089b02f984284b5eb3c05f7216d289bef7ae08a9e6c6f991b2a1a23a";
      name = "kdesu-5.71.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kdewebkit-5.71.0.tar.xz";
      sha256 = "04b8b90734ddf6d5e72ffa69707d473e1d1f8605ba06d4ceca83f4a1d195c65d";
      name = "kdewebkit-5.71.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kdnssd-5.71.0.tar.xz";
      sha256 = "bc269f0a74eee99d6c49550fc608450ced753a599cd03f77ea577af4c2e87958";
      name = "kdnssd-5.71.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kdoctools-5.71.0.tar.xz";
      sha256 = "1e2fcaa97a014e82f68c0c36591ce84568ead7abd59b66e534789103e162cd09";
      name = "kdoctools-5.71.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kemoticons-5.71.0.tar.xz";
      sha256 = "20bcb111971cc2e8c17b38a0c20aff7cf453174f885c4b4bcc5899141113e2fc";
      name = "kemoticons-5.71.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kfilemetadata-5.71.0.tar.xz";
      sha256 = "2e302958065157c1f9ea4a189bbca40b7dbed019767a3380e34e0b6a633c75fe";
      name = "kfilemetadata-5.71.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kglobalaccel-5.71.0.tar.xz";
      sha256 = "218d77aa4f6089d57932d627c4a46a8a4a5e964c2bfcee0d1c54338c25c7a06c";
      name = "kglobalaccel-5.71.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kguiaddons-5.71.0.tar.xz";
      sha256 = "c1f7bf540a689319962275916c0434f47ba5ed8f7d46a78704393163e32eccd2";
      name = "kguiaddons-5.71.0.tar.xz";
    };
  };
  kholidays = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kholidays-5.71.0.tar.xz";
      sha256 = "5469718d6ede7edb2ab06bbaff8af01567ba77ffe2160c2c2d47c666cfebf417";
      name = "kholidays-5.71.0.tar.xz";
    };
  };
  khtml = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/khtml-5.71.0.tar.xz";
      sha256 = "df8d2a4776f98e1490a21e71e31a2ea7694bc7452da35f88623b19214b6e1c10";
      name = "khtml-5.71.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/ki18n-5.71.0.tar.xz";
      sha256 = "f2fc8c40c10576da8b74070b7dc8e752fdd04204cb2bfe522f37a0458fbaf881";
      name = "ki18n-5.71.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kiconthemes-5.71.0.tar.xz";
      sha256 = "3fa986207e9d967840bd7a3f1af1e4d0105905012a0e4cf56f7ef1b3740b3496";
      name = "kiconthemes-5.71.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kidletime-5.71.0.tar.xz";
      sha256 = "1bcacd6c9ec8d65f93434f51d865723a50609ec074f88da2890a8f37ea8d207d";
      name = "kidletime-5.71.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kimageformats-5.71.0.tar.xz";
      sha256 = "0d6d6a8664e4a01df27e9970ec9ec10a92c1d43a00a3e9ef0471d740b4c93d94";
      name = "kimageformats-5.71.0.tar.xz";
    };
  };
  kinit = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kinit-5.71.0.tar.xz";
      sha256 = "6ea625bced2c19b0f3e5bb504775dd6764358f02412364a16cbad731c5c299b6";
      name = "kinit-5.71.0.tar.xz";
    };
  };
  kio = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kio-5.71.0.tar.xz";
      sha256 = "b972c8dede50be3e89babb5a536054759db2a87003e6df770c598c7c1c94b8d6";
      name = "kio-5.71.0.tar.xz";
    };
  };
  kirigami2 = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kirigami2-5.71.0.tar.xz";
      sha256 = "f323efb96a809dc9e572a0e68e04c4f485fc27f9ae65ffa3988830e348151356";
      name = "kirigami2-5.71.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kitemmodels-5.71.0.tar.xz";
      sha256 = "68205f09d63a916f236e2b3b729c0055377d852de48f7cf29fa7174ca97b84e7";
      name = "kitemmodels-5.71.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kitemviews-5.71.0.tar.xz";
      sha256 = "2843ef166ff5bf69c1132bbc09545b59ad208313c0acad71d0cd951fde1d33de";
      name = "kitemviews-5.71.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kjobwidgets-5.71.0.tar.xz";
      sha256 = "63f3b2fc1c062b1a485ff543e2d5afa68a9f9a918676bf3a6a5dc8f56f5f30e3";
      name = "kjobwidgets-5.71.0.tar.xz";
    };
  };
  kjs = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kjs-5.71.0.tar.xz";
      sha256 = "702224482139e500da1ea4e0d2b5132bf762f87f426f294587a0f2f47b9a9734";
      name = "kjs-5.71.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kjsembed-5.71.0.tar.xz";
      sha256 = "9352a31b5f735d71d6db4b09825ca01adb337e37f2b0cfce48c679e932238486";
      name = "kjsembed-5.71.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kmediaplayer-5.71.0.tar.xz";
      sha256 = "72492a6c877dded4f2333f140c025fdc4a271a68695c635c0dbc09b08d832eca";
      name = "kmediaplayer-5.71.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/knewstuff-5.71.0.tar.xz";
      sha256 = "aba867855d69641f73db30405e787fc9ea22e3386a45be9626ba84cbe208f855";
      name = "knewstuff-5.71.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/knotifications-5.71.0.tar.xz";
      sha256 = "b900146340621d54f6113600e85d287b28225d82515affb8690704433e5d0440";
      name = "knotifications-5.71.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/knotifyconfig-5.71.0.tar.xz";
      sha256 = "226b7f956f7013027621c4018b4376b76129ea4195df67fc7df4435c54baf50e";
      name = "knotifyconfig-5.71.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kpackage-5.71.0.tar.xz";
      sha256 = "c4b924e7c506cb75bdaaf68bd881e79a73999bd6436f29157f56c76f32b48cba";
      name = "kpackage-5.71.0.tar.xz";
    };
  };
  kparts = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kparts-5.71.0.tar.xz";
      sha256 = "d038f97dfdccdd85dbac09c0f64cf852191ec2e535fd7928740e03d4ffe63b90";
      name = "kparts-5.71.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kpeople-5.71.0.tar.xz";
      sha256 = "d63d5f5cbbedc2e4ef85fa8c2ff4adcd5cb9e05d1d1ee0e7b2c2d151193f5403";
      name = "kpeople-5.71.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kplotting-5.71.0.tar.xz";
      sha256 = "84bacfbd86105e454f3d97f4ac4062e2f992556fca66d2c73806d1d12095bec1";
      name = "kplotting-5.71.0.tar.xz";
    };
  };
  kpty = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kpty-5.71.0.tar.xz";
      sha256 = "7629d35ff783aff8fe801db30eb146efe50620f7500c4f7f1bf7d2619568c6b9";
      name = "kpty-5.71.0.tar.xz";
    };
  };
  kquickcharts = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kquickcharts-5.71.0.tar.xz";
      sha256 = "a1befe13903676a9779030b02b91da9889540e689e1f6a0afd54ff484109642a";
      name = "kquickcharts-5.71.0.tar.xz";
    };
  };
  kross = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kross-5.71.0.tar.xz";
      sha256 = "ac42ed4ec39ddaea0a4668803271f6f5de513fcdd1243d02b296544ab601bb1c";
      name = "kross-5.71.0.tar.xz";
    };
  };
  krunner = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/krunner-5.71.0.tar.xz";
      sha256 = "fb3ce4c587a1b114550487b5716f0aba53b775018b6eef2ae48b8d6fdda40952";
      name = "krunner-5.71.0.tar.xz";
    };
  };
  kservice = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kservice-5.71.0.tar.xz";
      sha256 = "6b7f4784cb514ec966f3cb01d26aa2dbdfd2425919efa57a4efa6117fcafc9ce";
      name = "kservice-5.71.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/ktexteditor-5.71.0.tar.xz";
      sha256 = "6e50b6669b288f8e624cba11bca53b78748faf6cb978628f02664038cfa294da";
      name = "ktexteditor-5.71.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/ktextwidgets-5.71.0.tar.xz";
      sha256 = "0a7fae03d8b59ec8a4f7c49a228536ea4121bd3d8f19fb1ff9831ada428509f4";
      name = "ktextwidgets-5.71.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kunitconversion-5.71.0.tar.xz";
      sha256 = "65bfba8e88e2cf6de40e06ce24fe5f48948cc92f16ce78eb8538de532dcf36cb";
      name = "kunitconversion-5.71.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kwallet-5.71.0.tar.xz";
      sha256 = "d53b5bc4bbe054101b012d63672efc30af6a5aea58f467037cab4735b6ace9b5";
      name = "kwallet-5.71.0.tar.xz";
    };
  };
  kwayland = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kwayland-5.71.0.tar.xz";
      sha256 = "369ba54b485214687e719bc9216e3bb50849df3af9a3ec0e95cf5d5687c847c2";
      name = "kwayland-5.71.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kwidgetsaddons-5.71.0.tar.xz";
      sha256 = "897077995bcf4125d0f90d2964500e718d2a3fd5f117e1b7906177ad13a5082e";
      name = "kwidgetsaddons-5.71.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kwindowsystem-5.71.0.tar.xz";
      sha256 = "a3613aea6fa73ebc53f28c011a6bca31ed157e29f85df767e617c44399360cda";
      name = "kwindowsystem-5.71.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/kxmlgui-5.71.0.tar.xz";
      sha256 = "2e4b2563daeedf35a54d38002c05d7c39017a36c0b8a19c236ea87324eebf7cc";
      name = "kxmlgui-5.71.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/portingAids/kxmlrpcclient-5.71.0.tar.xz";
      sha256 = "5947de8ec9cd57d8ccf6ea8a764066733d2633d93e11f94ecfb47a75e1e7a91f";
      name = "kxmlrpcclient-5.71.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/modemmanager-qt-5.71.0.tar.xz";
      sha256 = "b2e5e2a8b8fe2e9fb22bb7dc77177a975727991c6c0ee19d5a9b0a2ab513531d";
      name = "modemmanager-qt-5.71.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/networkmanager-qt-5.71.0.tar.xz";
      sha256 = "7fe6a0c9d9b25c434c6a200de19f722d942165252cc9161f1d8fcddf64147034";
      name = "networkmanager-qt-5.71.0.tar.xz";
    };
  };
  oxygen-icons5 = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/oxygen-icons5-5.71.0.tar.xz";
      sha256 = "a75a82164e2af5b6f269a386762ff2abba052dbfca18c9aed8d738c9cd958b04";
      name = "oxygen-icons5-5.71.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/plasma-framework-5.71.0.tar.xz";
      sha256 = "a54c8603ca261c89609a3009536a9217ce3415a7fd63527ed36f266399613067";
      name = "plasma-framework-5.71.0.tar.xz";
    };
  };
  prison = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/prison-5.71.0.tar.xz";
      sha256 = "44762ee7a3993bd7527f0b33ee09bacc1d5a518641b79932e5490a511ac7e87f";
      name = "prison-5.71.0.tar.xz";
    };
  };
  purpose = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/purpose-5.71.0.tar.xz";
      sha256 = "de0531a84f671a15fe4a6348220e922a3230178554e26baf392a1f295044e4be";
      name = "purpose-5.71.0.tar.xz";
    };
  };
  qqc2-desktop-style = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/qqc2-desktop-style-5.71.0.tar.xz";
      sha256 = "b968ce6fc7c1d111aa2c63584dddc0f74e9066a0b4ea26d1194e46e2f7b38700";
      name = "qqc2-desktop-style-5.71.0.tar.xz";
    };
  };
  solid = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/solid-5.71.0.tar.xz";
      sha256 = "72a7bdd8306ec4cda5f504819e0ff3f8baca6530fa04e33f10b6b89dc010505b";
      name = "solid-5.71.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/sonnet-5.71.0.tar.xz";
      sha256 = "cd663b3e1b23aef58d85f72dfdc92aaae33f358b22ad1fc36fde6c66eb7f0e72";
      name = "sonnet-5.71.0.tar.xz";
    };
  };
  syndication = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/syndication-5.71.0.tar.xz";
      sha256 = "c515fd48d3736b55c8e7990c72471bfddd55363c4bcb049713be741eaa7b07e0";
      name = "syndication-5.71.0.tar.xz";
    };
  };
  syntax-highlighting = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/syntax-highlighting-5.71.0.tar.xz";
      sha256 = "845ae0c7b8523c23c3ad704a6c551260a358d96b0094a5c2b062879e58173f84";
      name = "syntax-highlighting-5.71.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.71.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.71/threadweaver-5.71.0.tar.xz";
      sha256 = "039e73d70f38af38a63235cfb554111ee0d58a6ac168bff0745f0d029c5c528d";
      name = "threadweaver-5.71.0.tar.xz";
    };
  };
}
