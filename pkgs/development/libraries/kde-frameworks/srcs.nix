# DO NOT EDIT! This file is generated automatically.
<<<<<<< HEAD
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks/
=======
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
{ fetchurl, mirror }:

{
  attica = {
<<<<<<< HEAD
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/attica-5.110.0.tar.xz";
      sha256 = "1lp7y0r3npv93kcw1fkgl8c2njbs6y4m8cg32b60pyjahfqspxd6";
      name = "attica-5.110.0.tar.xz";
    };
  };
  baloo = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/baloo-5.110.0.tar.xz";
      sha256 = "0bg2nyp7zp1mka7ng8bwcd0hrbglrdiz7xw43r9q8wycr9qmva1n";
      name = "baloo-5.110.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/bluez-qt-5.110.0.tar.xz";
      sha256 = "1xvr85i0lkdpca64dzd7wqasc7acpzvh2kawl9nrfkrn96vrm0cz";
      name = "bluez-qt-5.110.0.tar.xz";
    };
  };
  breeze-icons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/breeze-icons-5.110.0.tar.xz";
      sha256 = "1m5z8g7rvilvwfn65yazci51i83ixv7fc5sh2v5vgxrlmhbysg0s";
      name = "breeze-icons-5.110.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/extra-cmake-modules-5.110.0.tar.xz";
      sha256 = "0f347y8q3ckgfq4skh2q69n67v3w9k680db0br4f43i37vdzaikp";
      name = "extra-cmake-modules-5.110.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/frameworkintegration-5.110.0.tar.xz";
      sha256 = "0ghl5p01g3jdj75wzyjwq4b0l0p98r0vkkf6zj6d3lbax207z0sq";
      name = "frameworkintegration-5.110.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kactivities-5.110.0.tar.xz";
      sha256 = "1c1456jc3s7cl2l3kmkgprgngip0j9c7ssd0b0fvjd41dwhzhra5";
      name = "kactivities-5.110.0.tar.xz";
    };
  };
  kactivities-stats = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kactivities-stats-5.110.0.tar.xz";
      sha256 = "1agqsdgbmglrzpg9w4df9qdg4hf8g1nnnkq7adp6cxsj3x8c8zx4";
      name = "kactivities-stats-5.110.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kapidox-5.110.0.tar.xz";
      sha256 = "1qi2mcslw0gsxc6p5q78lhg3if01j8dhxf0ypwb8njsfjcr45d24";
      name = "kapidox-5.110.0.tar.xz";
    };
  };
  karchive = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/karchive-5.110.0.tar.xz";
      sha256 = "1pqc0j4xkhwc6gdgg1q7pl3hjnrscwz8vbdz8jbvpaz51cy5iipw";
      name = "karchive-5.110.0.tar.xz";
    };
  };
  kauth = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kauth-5.110.0.tar.xz";
      sha256 = "1yymmyvhqgrwdpy5c2narh6d0ac41mw9ifrhckcyr22kdyrmgcz1";
      name = "kauth-5.110.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kbookmarks-5.110.0.tar.xz";
      sha256 = "1k04mcfciv3gq4qw5gkpq7189wfxxlr427h4827m3hs3ysbgc4vh";
      name = "kbookmarks-5.110.0.tar.xz";
    };
  };
  kcalendarcore = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcalendarcore-5.110.0.tar.xz";
      sha256 = "19zb1g4lbiqy4vcay6hbjx9ak5r00frfn1hahpc544q9l0dznl52";
      name = "kcalendarcore-5.110.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcmutils-5.110.0.tar.xz";
      sha256 = "0ccgrd757ww890nvajw1s9yvq6iikp316q123rfminrc0mlrpzaq";
      name = "kcmutils-5.110.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcodecs-5.110.0.tar.xz";
      sha256 = "1i15q8kg1dn72sxg9djvg9h4mhqh9rgvnsf3bz0pjd5jbwqqyv1v";
      name = "kcodecs-5.110.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcompletion-5.110.0.tar.xz";
      sha256 = "0a9l6p9kfg074wxz0r9dn43baibrbzbh80x60rds2jaf3yjg212g";
      name = "kcompletion-5.110.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kconfig-5.110.0.tar.xz";
      sha256 = "1i9idh0rh8ryry5gf22wwgzd15y14jymxjdxbkgx13kqpfyqhaxd";
      name = "kconfig-5.110.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kconfigwidgets-5.110.0.tar.xz";
      sha256 = "04mlw41xdps7qgnmmccqgs7jc5iipx2vqp9bd91l3sz4p90wj3sg";
      name = "kconfigwidgets-5.110.0.tar.xz";
    };
  };
  kcontacts = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcontacts-5.110.0.tar.xz";
      sha256 = "0gib8nlis59kbhydqvf6alwxvy4db94r2p3vpbcdy48gc4i06344";
      name = "kcontacts-5.110.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcoreaddons-5.110.0.tar.xz";
      sha256 = "0xcd2ph62a7kbm8camp1vnsxlaq1kmqm9hw9gyphcdh0rh6fi3bf";
      name = "kcoreaddons-5.110.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kcrash-5.110.0.tar.xz";
      sha256 = "15j70r6afc0lyg41047r27l089gkq8fh39w9iyvhv0h8hfxxah6g";
      name = "kcrash-5.110.0.tar.xz";
    };
  };
  kdav = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdav-5.110.0.tar.xz";
      sha256 = "0qz5iq9fi1vk1z7w4wdh7kxrc06vnyrvs7n0llyrjaprzjn8yx6a";
      name = "kdav-5.110.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdbusaddons-5.110.0.tar.xz";
      sha256 = "0ilzk67h5cxrjf78hw505pvbqvd2lkjk3m0g188pcw0sdg10xb8h";
      name = "kdbusaddons-5.110.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdeclarative-5.110.0.tar.xz";
      sha256 = "1vcqdi4lji97wm5vil2p1g7wi6rwrz0g6aiqf1nzi026fpsc8njj";
      name = "kdeclarative-5.110.0.tar.xz";
    };
  };
  kded = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kded-5.110.0.tar.xz";
      sha256 = "1n8hzkwhqrx4mb7ahqnkga01zslcp82ya22hppfapldy83bfrgyl";
      name = "kded-5.110.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kdelibs4support-5.110.0.tar.xz";
      sha256 = "119hhc0f862kzr5flrlpg9b8xlcl1qxa5xkccad0hpba76pk2af4";
      name = "kdelibs4support-5.110.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kdesignerplugin-5.110.0.tar.xz";
      sha256 = "146i8n9rrajh03x180z48qi8dn31dywsz052bhbn4yw61ag4w4nc";
      name = "kdesignerplugin-5.110.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdesu-5.110.0.tar.xz";
      sha256 = "0ll5k4lpn1v4bc365w2ky0qszikfz2r589ni8iyk109qdqciyrr9";
      name = "kdesu-5.110.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kdewebkit-5.110.0.tar.xz";
      sha256 = "0p09lby7csx3j513lm91k247iwxby423cz7da51n20qncan8g65v";
      name = "kdewebkit-5.110.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdnssd-5.110.0.tar.xz";
      sha256 = "0xmahgn572ah8ji4d4afalcl7r2krn971ix5jwcqgrj57m5haj45";
      name = "kdnssd-5.110.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kdoctools-5.110.0.tar.xz";
      sha256 = "1g05gppc6qzkag1x18anymbwdswpg32w6jh12x9jfj79vcp7wg4j";
      name = "kdoctools-5.110.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kemoticons-5.110.0.tar.xz";
      sha256 = "1r1d3kw6wzw63kq9wy4ic2b9hcnmm4rs7v9f1z9jhq9m1jp0zy12";
      name = "kemoticons-5.110.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kfilemetadata-5.110.0.tar.xz";
      sha256 = "07ma48iq5vpnj391shm3s9an3rqhxskfziw6pksmzxxnga0whbl9";
      name = "kfilemetadata-5.110.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kglobalaccel-5.110.0.tar.xz";
      sha256 = "1iw22vyrk07pzcsh41cvfp8i8589jm1yqn1cx1ad5rmryzsjalzp";
      name = "kglobalaccel-5.110.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kguiaddons-5.110.0.tar.xz";
      sha256 = "0ajmxj8nhis6f4hwd64s9qfw3hbip80xrdy3d1wksykbq7g5b89c";
      name = "kguiaddons-5.110.0.tar.xz";
    };
  };
  kholidays = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kholidays-5.110.0.tar.xz";
      sha256 = "0zikajmic93wqgy9865pf61sdlnsyzzf2jal7bj25is7a1mk8mjc";
      name = "kholidays-5.110.0.tar.xz";
    };
  };
  khtml = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/khtml-5.110.0.tar.xz";
      sha256 = "17d87vjim32mn0s1d9zl9342aamqg4xmi6xh6d8ghrgms3vqc7in";
      name = "khtml-5.110.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/ki18n-5.110.0.tar.xz";
      sha256 = "03qks9kncvazq2wz3myrjgz5m0gjxm80m1ayv9vjndyyc74a9smw";
      name = "ki18n-5.110.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kiconthemes-5.110.0.tar.xz";
      sha256 = "0bb6r7jaknjyhyjhdrlji320qgb7cgxshcgab0209zk8dl8a510d";
      name = "kiconthemes-5.110.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kidletime-5.110.0.tar.xz";
      sha256 = "0hc30778d1k0vm4qsp58cf3d5bnws328qxazm8d5a6kxdc7izz44";
      name = "kidletime-5.110.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kimageformats-5.110.0.tar.xz";
      sha256 = "0ivks2c2kgd26pr0n0b4x3hb7dmmq52vlp7f6ny14qpvm3cgnscd";
      name = "kimageformats-5.110.0.tar.xz";
    };
  };
  kinit = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kinit-5.110.0.tar.xz";
      sha256 = "0ps2299hf02yvgs971cb4bljbmdbcvcmm2xqz6q0h8asjkpkilv5";
      name = "kinit-5.110.0.tar.xz";
    };
  };
  kio = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kio-5.110.0.tar.xz";
      sha256 = "0sy91zlk60q5jligxp870srfc6fhd3fyk5yamkg266yfvyy9m3r2";
      name = "kio-5.110.0.tar.xz";
    };
  };
  kirigami2 = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kirigami2-5.110.0.tar.xz";
      sha256 = "13j9z0nha3wq97apgkj43bayqijpgy6a2l7f9iryww054aqdjggx";
      name = "kirigami2-5.110.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kitemmodels-5.110.0.tar.xz";
      sha256 = "06gym33644npci4crhykyfyp2v74pya72kdzmqh4lkzp252pyfhj";
      name = "kitemmodels-5.110.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kitemviews-5.110.0.tar.xz";
      sha256 = "1nqbypn0crbaqa8x19z0fh8mqbr8wbf8nc8wg0irzp32js9vcqyp";
      name = "kitemviews-5.110.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kjobwidgets-5.110.0.tar.xz";
      sha256 = "1bl7igakmh1ipiamigs5s8fj6fy905b3j1dqgq9hxdxk59k1r1h2";
      name = "kjobwidgets-5.110.0.tar.xz";
    };
  };
  kjs = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kjs-5.110.0.tar.xz";
      sha256 = "0xlkdi7qs75ipf87h8m7bvjn4l28y5qy20hvag1gc370fxz54v15";
      name = "kjs-5.110.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kjsembed-5.110.0.tar.xz";
      sha256 = "1ynmj8ac9g9amjz0ljz3wf7sjsrwmz1kfi26r36rpqlf9mmkzfqm";
      name = "kjsembed-5.110.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kmediaplayer-5.110.0.tar.xz";
      sha256 = "1jhh3gsbibi2hrhswg1nz1mdxn2wir5p9cvqpcqv7k8vm6rb82z3";
      name = "kmediaplayer-5.110.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/knewstuff-5.110.0.tar.xz";
      sha256 = "0qld8ijy7z60qdlwa9vaq905xgzyvh5zw6ymngs00axl33m9bbbl";
      name = "knewstuff-5.110.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/knotifications-5.110.0.tar.xz";
      sha256 = "0zm3d36v9dgqb3pdwpj962wpngfhq08q9x9rj99f88g9dlnmy6gm";
      name = "knotifications-5.110.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/knotifyconfig-5.110.0.tar.xz";
      sha256 = "1651rh0av8lqp8rmb3djizsb8ypihkabprgppla3af2xf446n7wp";
      name = "knotifyconfig-5.110.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kpackage-5.110.0.tar.xz";
      sha256 = "1jd85m7pxzah9d6b3zi2nswvsinx85brkiq142vic5l0rm6l89id";
      name = "kpackage-5.110.0.tar.xz";
    };
  };
  kparts = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kparts-5.110.0.tar.xz";
      sha256 = "13av8v2kggbvyv8nxganjb88q38g3gbykbkwrigywc3767p838r3";
      name = "kparts-5.110.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kpeople-5.110.0.tar.xz";
      sha256 = "10drcfjcw00qhdlsficxb07hnnsd93smcig8argznpgwd61f807p";
      name = "kpeople-5.110.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kplotting-5.110.0.tar.xz";
      sha256 = "1fbzy9k0gx1468qsdd1c8fqaml3c01yy0m6n205y3ymkca78hdbk";
      name = "kplotting-5.110.0.tar.xz";
    };
  };
  kpty = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kpty-5.110.0.tar.xz";
      sha256 = "1cx9wszi9zlay0vb9wz9hgbmbq006xgssnzzrmby4q4s6bhb92ps";
      name = "kpty-5.110.0.tar.xz";
    };
  };
  kquickcharts = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kquickcharts-5.110.0.tar.xz";
      sha256 = "0s8xnsmhx2m6wn7fmmddzwnwc2yr3kvy85vd65m3avfw073rgj5v";
      name = "kquickcharts-5.110.0.tar.xz";
    };
  };
  kross = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kross-5.110.0.tar.xz";
      sha256 = "169zsxrmbdv5xn6s0wmf1l2a3qghn88hgl714i0cnymq5ixy25x5";
      name = "kross-5.110.0.tar.xz";
    };
  };
  krunner = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/krunner-5.110.0.tar.xz";
      sha256 = "0q3jhq2cswnqj5rdkxhizlv06rsxsm38ipxhcsw6p8zqabi1i351";
      name = "krunner-5.110.0.tar.xz";
    };
  };
  kservice = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kservice-5.110.0.tar.xz";
      sha256 = "0rin6v96mcmw53dzw8sw56g7188623d1k4vs18bv44l86gixdhgg";
      name = "kservice-5.110.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/ktexteditor-5.110.0.tar.xz";
      sha256 = "0iwzw51km3mr8kdva14mxz9bvcfcf09v5igah2axkjaxazxyigla";
      name = "ktexteditor-5.110.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/ktextwidgets-5.110.0.tar.xz";
      sha256 = "0cr7n58mak928dysyqhsr1pj0w90amikx9jav4gs4lzb4m4rjp7q";
      name = "ktextwidgets-5.110.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kunitconversion-5.110.0.tar.xz";
      sha256 = "083w0gz157j2g8qzm03yq3qwq58wafcq26qcc2ly2fksyyxkzzda";
      name = "kunitconversion-5.110.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kwallet-5.110.0.tar.xz";
      sha256 = "0mg5y8cvzvs7w3yy5xnpsps2b6m476l5ilw5kvarrjjpq7ybnkqz";
      name = "kwallet-5.110.0.tar.xz";
    };
  };
  kwayland = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kwayland-5.110.0.tar.xz";
      sha256 = "0ggxvywvqfhhhb5370n90dyw0mjwkp3i7rgv58nyqsmby0g08r85";
      name = "kwayland-5.110.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kwidgetsaddons-5.110.0.tar.xz";
      sha256 = "1cyphs0r5j2v93pwi9mbn6xd928lnhb0zmyfj5pywdx9n7lv0x6a";
      name = "kwidgetsaddons-5.110.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kwindowsystem-5.110.0.tar.xz";
      sha256 = "0l3aknr3zqz9zwqlyhnr8n53bcfb22rm38vdiv0l5vpwjbjn0270";
      name = "kwindowsystem-5.110.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/kxmlgui-5.110.0.tar.xz";
      sha256 = "1j8v52ix9sv7q76cvl2gnpjs602ri57kgfh21bvqd88gf2xnwxjq";
      name = "kxmlgui-5.110.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/portingAids/kxmlrpcclient-5.110.0.tar.xz";
      sha256 = "0fzd9amj2j4bw54q8fbgczqf785s6siqr1a8wbqf56wyyhki5psx";
      name = "kxmlrpcclient-5.110.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/modemmanager-qt-5.110.0.tar.xz";
      sha256 = "08q43arx9q81rqwhczzcn4cyl5glalwzjncb120a2cihida2m71v";
      name = "modemmanager-qt-5.110.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/networkmanager-qt-5.110.0.tar.xz";
      sha256 = "1bnlvpfhw6l64rgaxx9zkxd5wmwvyal5xmv31vxzf92ig6sgjdqq";
      name = "networkmanager-qt-5.110.0.tar.xz";
    };
  };
  oxygen-icons5 = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/oxygen-icons5-5.110.0.tar.xz";
      sha256 = "1dmig458gbl0ypb99kj514nwl5gbjpfvixw9lipgc2wwnn1nkia2";
      name = "oxygen-icons5-5.110.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/plasma-framework-5.110.0.tar.xz";
      sha256 = "0jfln8lrzmcnkqhl8pij5w6mdj6g25rwc332f07g9465y9ap07cf";
      name = "plasma-framework-5.110.0.tar.xz";
    };
  };
  prison = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/prison-5.110.0.tar.xz";
      sha256 = "019a3z18gq7nb3ahf5dd3b5fixzyfklg60dk2w4win2w19s70wb7";
      name = "prison-5.110.0.tar.xz";
    };
  };
  purpose = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/purpose-5.110.0.tar.xz";
      sha256 = "0nl6qh7j5c3ijnq0qw1a5jmj1x5nb9hlssjjn8fdvfr7q6z67rsc";
      name = "purpose-5.110.0.tar.xz";
    };
  };
  qqc2-desktop-style = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/qqc2-desktop-style-5.110.0.tar.xz";
      sha256 = "04pyhlr89azw0kyjxfpx6phxljck8yiflcszd4xkgiw3n9rjyg3g";
      name = "qqc2-desktop-style-5.110.0.tar.xz";
    };
  };
  solid = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/solid-5.110.0.tar.xz";
      sha256 = "1k64cqlws7nxki21cwg197avfnxsxpw3isry5p7bqyfmq45ydcvd";
      name = "solid-5.110.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/sonnet-5.110.0.tar.xz";
      sha256 = "16qk63yy1y03z4rlc08qzr7mmds1yz0k9x1ws2nzp47khkza250i";
      name = "sonnet-5.110.0.tar.xz";
    };
  };
  syndication = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/syndication-5.110.0.tar.xz";
      sha256 = "0dsd05ckfv9fdnrbgprriba7lbbfs2z9qv869pcr4n7pn7x778sd";
      name = "syndication-5.110.0.tar.xz";
    };
  };
  syntax-highlighting = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/syntax-highlighting-5.110.0.tar.xz";
      sha256 = "0gbmgan0cy4xhjcf10g0lffhwvkhhpcgbnk190xlzl4chnmpq9w5";
      name = "syntax-highlighting-5.110.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.110.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.110/threadweaver-5.110.0.tar.xz";
      sha256 = "085y4m7z0rybsvpqzl2sjwnf8yjm4lnc3n49idj2c0psm8v5ksm0";
      name = "threadweaver-5.110.0.tar.xz";
=======
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/attica-5.106.0.tar.xz";
      sha256 = "0kjpb26r6vgnl0pg1aaqya40zsp8mq9x1824r2zifb6g7b9061bc";
      name = "attica-5.106.0.tar.xz";
    };
  };
  baloo = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/baloo-5.106.0.tar.xz";
      sha256 = "1g92hz28mh6i2jxnzcda5g0n6474xjaxkgn8a31yfwqaga7f2sjf";
      name = "baloo-5.106.0.tar.xz";
    };
  };
  bluez-qt = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/bluez-qt-5.106.0.tar.xz";
      sha256 = "1k3ss4jdyslv6hnrg8zlwhx5795wlr3zaqg58y3jc0lfjvrq7sri";
      name = "bluez-qt-5.106.0.tar.xz";
    };
  };
  breeze-icons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/breeze-icons-5.106.0.tar.xz";
      sha256 = "18ih97058x0hc0rxaljwddjls5kqzxkhh705sn340gb63iyggvlr";
      name = "breeze-icons-5.106.0.tar.xz";
    };
  };
  extra-cmake-modules = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/extra-cmake-modules-5.106.0.tar.xz";
      sha256 = "165m7kk7kqms57m951zckdl61x29h7wgabs7a5g4hdsxmkn5hks0";
      name = "extra-cmake-modules-5.106.0.tar.xz";
    };
  };
  frameworkintegration = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/frameworkintegration-5.106.0.tar.xz";
      sha256 = "0hb1a417r6s89s8086y40fa92qkbwj1w542n1hf5prdc90cxmxd7";
      name = "frameworkintegration-5.106.0.tar.xz";
    };
  };
  kactivities = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kactivities-5.106.0.tar.xz";
      sha256 = "00bpj23iivnhn1kikqhvb0x44brcx6w5826n0bz7frpn3mwwdc04";
      name = "kactivities-5.106.0.tar.xz";
    };
  };
  kactivities-stats = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kactivities-stats-5.106.0.tar.xz";
      sha256 = "1jmdcx26b3m9sbphk0fqvclng8gcpjlijjm0m49sik34kz5ypjv2";
      name = "kactivities-stats-5.106.0.tar.xz";
    };
  };
  kapidox = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kapidox-5.106.0.tar.xz";
      sha256 = "0cndjyps3k8zqmc17ydr87mdcbvl5gqs4rcixnlgcl6ql9ql312f";
      name = "kapidox-5.106.0.tar.xz";
    };
  };
  karchive = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/karchive-5.106.0.tar.xz";
      sha256 = "15m5smli1v5ab2mi50f9rrxcjqv329ssjysy1aihn05vjj75l7pw";
      name = "karchive-5.106.0.tar.xz";
    };
  };
  kauth = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kauth-5.106.0.tar.xz";
      sha256 = "00v5m91m2rs4wc20vrz9nl3pls7mpsv4rc89vcvk2hlc0m0kxbiw";
      name = "kauth-5.106.0.tar.xz";
    };
  };
  kbookmarks = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kbookmarks-5.106.0.tar.xz";
      sha256 = "0a1nyflm5xa3w92428my2rbg3v2mplacgskywgb61m3a5ba1accd";
      name = "kbookmarks-5.106.0.tar.xz";
    };
  };
  kcalendarcore = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcalendarcore-5.106.0.tar.xz";
      sha256 = "01cnb31czw9vd41bkn65caxahpps43wrcvqllsyyn18wpiwdsy7l";
      name = "kcalendarcore-5.106.0.tar.xz";
    };
  };
  kcmutils = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcmutils-5.106.0.tar.xz";
      sha256 = "1n18c7gs644rypzi27hzfw5y9wsrgflnyb343sfxjm5fmcycknnp";
      name = "kcmutils-5.106.0.tar.xz";
    };
  };
  kcodecs = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcodecs-5.106.0.tar.xz";
      sha256 = "18sy6qk7lfl3cqfc9j7ajz3rphdab4x0q32sg2l1cxblww9l5pgm";
      name = "kcodecs-5.106.0.tar.xz";
    };
  };
  kcompletion = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcompletion-5.106.0.tar.xz";
      sha256 = "06vzs7jkwcarf90nywpx743b48n84xb4zxky7fr9hphkw44xc9m5";
      name = "kcompletion-5.106.0.tar.xz";
    };
  };
  kconfig = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kconfig-5.106.0.tar.xz";
      sha256 = "0bahfmz0cp4i5p78yxhwjps9csji2fal5cgrgry1q7lpvgblwa85";
      name = "kconfig-5.106.0.tar.xz";
    };
  };
  kconfigwidgets = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kconfigwidgets-5.106.0.tar.xz";
      sha256 = "0xlvixg7pjiaqw6yzgkqpyfrnrmsxnbpxvkngbx1l1aqn181bv05";
      name = "kconfigwidgets-5.106.0.tar.xz";
    };
  };
  kcontacts = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcontacts-5.106.0.tar.xz";
      sha256 = "1m0zlw63b6i8bqq404amsdfgpdasgir8zvc0vd90vnkqb7vg5dz5";
      name = "kcontacts-5.106.0.tar.xz";
    };
  };
  kcoreaddons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcoreaddons-5.106.0.tar.xz";
      sha256 = "0z60gk1dg5q8brlpyqk3465gxf6v2h1rp1icv4k2fh7wv7850378";
      name = "kcoreaddons-5.106.0.tar.xz";
    };
  };
  kcrash = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kcrash-5.106.0.tar.xz";
      sha256 = "0jr4y7289h4jklzkkrx03l88rbsq8rpkkli0a03zl9jq5p9jd7jj";
      name = "kcrash-5.106.0.tar.xz";
    };
  };
  kdav = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdav-5.106.0.tar.xz";
      sha256 = "1amlg8vjh6r32vc330l57kvjnf55wyp9cy5bw28dbjavgxc0jcqp";
      name = "kdav-5.106.0.tar.xz";
    };
  };
  kdbusaddons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdbusaddons-5.106.0.tar.xz";
      sha256 = "05ycxaqbnf0065mmijxlbr9yiza3zrrsafn3h60pw7v8k5cb90w1";
      name = "kdbusaddons-5.106.0.tar.xz";
    };
  };
  kdeclarative = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdeclarative-5.106.0.tar.xz";
      sha256 = "0fg42lxfs69jhc8pqilkhsmpjncq4akjmnlq9fwc07imlnqqjf65";
      name = "kdeclarative-5.106.0.tar.xz";
    };
  };
  kded = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kded-5.106.0.tar.xz";
      sha256 = "1a16c7g4zd4cw51afpjkvhr5y11552nwslbcl4r57nix38lz6r1r";
      name = "kded-5.106.0.tar.xz";
    };
  };
  kdelibs4support = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kdelibs4support-5.106.0.tar.xz";
      sha256 = "1aww59z7i7dnmi5a93ifrrcc2maqd5h8wl3cf9sxp6rp3h56awff";
      name = "kdelibs4support-5.106.0.tar.xz";
    };
  };
  kdesignerplugin = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kdesignerplugin-5.106.0.tar.xz";
      sha256 = "1p55r35likclr88pmxw7jlvbfpyrc9xp3gx045j6i5z7dhl09dz0";
      name = "kdesignerplugin-5.106.0.tar.xz";
    };
  };
  kdesu = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdesu-5.106.0.tar.xz";
      sha256 = "1vbm5lx5sl3cf65xx45pd77cl2m3g64d7x9h8q23f3dr7y4bvs5b";
      name = "kdesu-5.106.0.tar.xz";
    };
  };
  kdewebkit = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kdewebkit-5.106.0.tar.xz";
      sha256 = "1h3q7x2lzd0cbxy1igchgyygjwg62n8w2m0p3bs93v78xfadz8ql";
      name = "kdewebkit-5.106.0.tar.xz";
    };
  };
  kdnssd = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdnssd-5.106.0.tar.xz";
      sha256 = "1fz89ix1kp7kjv54m4ks7vgrmr0qm2g1yqs4w1g8dr80fzd1fxhi";
      name = "kdnssd-5.106.0.tar.xz";
    };
  };
  kdoctools = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kdoctools-5.106.0.tar.xz";
      sha256 = "0k7c96414j9n5li0ffrnh762vmxf03cnkg8x0539x45xivdlkcn6";
      name = "kdoctools-5.106.0.tar.xz";
    };
  };
  kemoticons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kemoticons-5.106.0.tar.xz";
      sha256 = "0kbv093c3xf2iyqpk49hsqqqz55q4k10dqk7fdz3ygwvjdv1r4mx";
      name = "kemoticons-5.106.0.tar.xz";
    };
  };
  kfilemetadata = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kfilemetadata-5.106.0.tar.xz";
      sha256 = "1lijra8q6zp5hrc9hzaq70jx18azidljs3h8kn0j7wb480l4kcn5";
      name = "kfilemetadata-5.106.0.tar.xz";
    };
  };
  kglobalaccel = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kglobalaccel-5.106.0.tar.xz";
      sha256 = "005i4bq0a04nqs195ai55nm5cfajzlj1g15qn1fmx439hs9clz3m";
      name = "kglobalaccel-5.106.0.tar.xz";
    };
  };
  kguiaddons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kguiaddons-5.106.0.tar.xz";
      sha256 = "1mdqjklmfz9m1rkncrn621zmsmn96yaw82v8wbsnw1l6dhimf8r9";
      name = "kguiaddons-5.106.0.tar.xz";
    };
  };
  kholidays = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kholidays-5.106.0.tar.xz";
      sha256 = "0p9vxapjmkpzm4v2wwh1xfk4n6p4fhq0qx58k1c4ml5x9kczsr8a";
      name = "kholidays-5.106.0.tar.xz";
    };
  };
  khtml = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/khtml-5.106.0.tar.xz";
      sha256 = "11ld9glmir11gg36lknppv71ipryw49rx5cb9mbvkakp3q78f992";
      name = "khtml-5.106.0.tar.xz";
    };
  };
  ki18n = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/ki18n-5.106.0.tar.xz";
      sha256 = "0k4vgg2k5hsx9sr6pjq0a1ji7l2q908hlxd0i6gzk74v4jrina7i";
      name = "ki18n-5.106.0.tar.xz";
    };
  };
  kiconthemes = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kiconthemes-5.106.0.tar.xz";
      sha256 = "0sm28yn1wq5jyq6nq0kmjyqi53f9pkshvf9bs88rkb4m7yv5jkzb";
      name = "kiconthemes-5.106.0.tar.xz";
    };
  };
  kidletime = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kidletime-5.106.0.tar.xz";
      sha256 = "1x9n8zz7c4yndiv3jx8f8hscxxn4lcq1n949m6m6vj51a466ipx4";
      name = "kidletime-5.106.0.tar.xz";
    };
  };
  kimageformats = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kimageformats-5.106.0.tar.xz";
      sha256 = "13qfg4r8qxhxsvlmpk0m2iqlv3cknk55qykqa58z7z4pxf53wgzv";
      name = "kimageformats-5.106.0.tar.xz";
    };
  };
  kinit = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kinit-5.106.0.tar.xz";
      sha256 = "19fmg7lhrk4cjzrddgri4mx7hs06r9si7bw7x762sk794qj3jgxg";
      name = "kinit-5.106.0.tar.xz";
    };
  };
  kio = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kio-5.106.0.tar.xz";
      sha256 = "1dnc11cprs32rg57lmi2dlhs08jfi6n39i62cwnzk7qn49j9fbzd";
      name = "kio-5.106.0.tar.xz";
    };
  };
  kirigami2 = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kirigami2-5.106.0.tar.xz";
      sha256 = "0q7inx457klw55g3v2js1r0d50wd9jd73h2jq99l0sjad82djvzm";
      name = "kirigami2-5.106.0.tar.xz";
    };
  };
  kitemmodels = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kitemmodels-5.106.0.tar.xz";
      sha256 = "055jznkg4gfkd39p10s115b696h7acfcc0vqdqdr4x1iv0l8z9r2";
      name = "kitemmodels-5.106.0.tar.xz";
    };
  };
  kitemviews = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kitemviews-5.106.0.tar.xz";
      sha256 = "1migbbxi163jxjw6i0n5xf6y086m0xszr7mjgpnb1i9mm4s8b8m8";
      name = "kitemviews-5.106.0.tar.xz";
    };
  };
  kjobwidgets = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kjobwidgets-5.106.0.tar.xz";
      sha256 = "0wgyis5xramhk3rrmva0zi1kyndvk36xahc6sycq51ca9mzkq0sk";
      name = "kjobwidgets-5.106.0.tar.xz";
    };
  };
  kjs = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kjs-5.106.0.tar.xz";
      sha256 = "0jajzndp470vqh0d4yli8yvkjg1i95j6wxf6zs7yjqzq7xdjkgw2";
      name = "kjs-5.106.0.tar.xz";
    };
  };
  kjsembed = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kjsembed-5.106.0.tar.xz";
      sha256 = "0ghmdlwgbf3la8kc9303yc4ababi45ynw7z6xf7p5shvzlk6k109";
      name = "kjsembed-5.106.0.tar.xz";
    };
  };
  kmediaplayer = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kmediaplayer-5.106.0.tar.xz";
      sha256 = "15923qbs74xkzawwa8qlplzpaal252hiapmngiirvaf7xbkik0k5";
      name = "kmediaplayer-5.106.0.tar.xz";
    };
  };
  knewstuff = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/knewstuff-5.106.0.tar.xz";
      sha256 = "02kwz5axahvrnzccxifp720bqvdcb5c15lqb7s9bkydcbmb6x3cx";
      name = "knewstuff-5.106.0.tar.xz";
    };
  };
  knotifications = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/knotifications-5.106.0.tar.xz";
      sha256 = "16la3ylz7lfhkara3rlx7yx8b1sfwi6n9z3vrin9qrg9pqlxn96g";
      name = "knotifications-5.106.0.tar.xz";
    };
  };
  knotifyconfig = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/knotifyconfig-5.106.0.tar.xz";
      sha256 = "100pavdyxywqci13dh5pryg955xjxdwy28k4fgri7cqr6hp8mndm";
      name = "knotifyconfig-5.106.0.tar.xz";
    };
  };
  kpackage = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kpackage-5.106.0.tar.xz";
      sha256 = "0k1zw5jn9rg4hqpcbrmvqchd57ckzw1fpks4csnyjav4crf2j9d2";
      name = "kpackage-5.106.0.tar.xz";
    };
  };
  kparts = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kparts-5.106.0.tar.xz";
      sha256 = "19npas4ww61zd9j2hx19dbpm2041rq2i80ybf815k6sx2yz4ac38";
      name = "kparts-5.106.0.tar.xz";
    };
  };
  kpeople = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kpeople-5.106.0.tar.xz";
      sha256 = "0n3v3l7k0xyl7p6yj74vh220nrxv0c3b6s1cmq6n8cr1j93203iy";
      name = "kpeople-5.106.0.tar.xz";
    };
  };
  kplotting = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kplotting-5.106.0.tar.xz";
      sha256 = "11fpccs0ljm8rgxbgsbw9x2pgs9l1km8x0i7bj8cdm5mvaimxif7";
      name = "kplotting-5.106.0.tar.xz";
    };
  };
  kpty = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kpty-5.106.0.tar.xz";
      sha256 = "1wig5mkgmi4gkvwd5xzcq4yna8rj6sqfpdsr0xd618qhijr6s6lc";
      name = "kpty-5.106.0.tar.xz";
    };
  };
  kquickcharts = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kquickcharts-5.106.0.tar.xz";
      sha256 = "1s44gxgqwb6ry9v4277i26pcv264xw6s9c9n5amynjk3pvfavcd4";
      name = "kquickcharts-5.106.0.tar.xz";
    };
  };
  kross = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kross-5.106.0.tar.xz";
      sha256 = "0pvbmywjw9rmafk5cpap4yib7lgayqb325zbid28aiaydi3ksc2y";
      name = "kross-5.106.0.tar.xz";
    };
  };
  krunner = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/krunner-5.106.0.tar.xz";
      sha256 = "02q0dcmmax47fc049zbfbrmvjhfpkmin5kfg8h26kpplhfxil4q5";
      name = "krunner-5.106.0.tar.xz";
    };
  };
  kservice = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kservice-5.106.0.tar.xz";
      sha256 = "0grpkk98l9g0f49c1vnrk3l19k1468a4lj2zkzr09sk1mrwvz18l";
      name = "kservice-5.106.0.tar.xz";
    };
  };
  ktexteditor = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/ktexteditor-5.106.0.tar.xz";
      sha256 = "11jz2zsyb0nk4c7mjqcbkb5gfgzwm9dc6am7wjlzf16l2l2xr3f3";
      name = "ktexteditor-5.106.0.tar.xz";
    };
  };
  ktextwidgets = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/ktextwidgets-5.106.0.tar.xz";
      sha256 = "1bd8cdxjp97a4y6548igpzc49q60iiqhaycnxjz5v23zx9ggrqjg";
      name = "ktextwidgets-5.106.0.tar.xz";
    };
  };
  kunitconversion = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kunitconversion-5.106.0.tar.xz";
      sha256 = "10dyn84lffwh6j3qhp1sl1dggsmci577jggsrqp7xlxkjpm1l1xj";
      name = "kunitconversion-5.106.0.tar.xz";
    };
  };
  kwallet = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kwallet-5.106.0.tar.xz";
      sha256 = "1n2mbd17d22k8jf53m8igrnvqdfsv97bd4scf32s976ij3rdx58l";
      name = "kwallet-5.106.0.tar.xz";
    };
  };
  kwayland = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kwayland-5.106.0.tar.xz";
      sha256 = "0mjzhqcwaaz3269fw5r8i8lv7w0zg9sp3qzkbbbd6kls8pn8mxry";
      name = "kwayland-5.106.0.tar.xz";
    };
  };
  kwidgetsaddons = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kwidgetsaddons-5.106.0.tar.xz";
      sha256 = "1k0qs5pl2ca52ywaxnkpahshj5h7yvfpsr1ydd2a7bniciqvw0dp";
      name = "kwidgetsaddons-5.106.0.tar.xz";
    };
  };
  kwindowsystem = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kwindowsystem-5.106.0.tar.xz";
      sha256 = "032836xkybmf3fx39vp535j0cnaxfy65f5ky5w189j6haqjl6w9k";
      name = "kwindowsystem-5.106.0.tar.xz";
    };
  };
  kxmlgui = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/kxmlgui-5.106.0.tar.xz";
      sha256 = "1ahqgya1mlys6s1c9h15rw421fh04brlv740qqi5kjvg5h69ibs4";
      name = "kxmlgui-5.106.0.tar.xz";
    };
  };
  kxmlrpcclient = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/portingAids/kxmlrpcclient-5.106.0.tar.xz";
      sha256 = "1zrmc9xiwrdf4l8h4p1lmp3nls40p1878xxvyj34ba7yiylh4a1r";
      name = "kxmlrpcclient-5.106.0.tar.xz";
    };
  };
  modemmanager-qt = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/modemmanager-qt-5.106.0.tar.xz";
      sha256 = "14d4xyn8fhwf6ci0mmydcb31p6d0drr6484z08nillbvy5w075bv";
      name = "modemmanager-qt-5.106.0.tar.xz";
    };
  };
  networkmanager-qt = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/networkmanager-qt-5.106.0.tar.xz";
      sha256 = "07cygd6zx8c7rggf796n1apnrsfmqc87sj7sy78ibkzjhxwxpar6";
      name = "networkmanager-qt-5.106.0.tar.xz";
    };
  };
  oxygen-icons5 = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/oxygen-icons5-5.106.0.tar.xz";
      sha256 = "11jhqr4g87cbmsirb3ydi1iz1fknks6l91mim1263xzbr89q3k1d";
      name = "oxygen-icons5-5.106.0.tar.xz";
    };
  };
  plasma-framework = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/plasma-framework-5.106.0.tar.xz";
      sha256 = "0749jc4cjq3l5pg63dn6kbf4sc5sq7czq2jkhqixbcwfgqhy1csc";
      name = "plasma-framework-5.106.0.tar.xz";
    };
  };
  prison = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/prison-5.106.0.tar.xz";
      sha256 = "1nrvcjq2wr5v0zppvsb028vj664c5lbhd2plbgkjdgfrvqlm3c4g";
      name = "prison-5.106.0.tar.xz";
    };
  };
  purpose = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/purpose-5.106.0.tar.xz";
      sha256 = "1nkj1cy5xyd2ycarx41m40k88wldrskk4kyyv71hapnir56l77w1";
      name = "purpose-5.106.0.tar.xz";
    };
  };
  qqc2-desktop-style = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/qqc2-desktop-style-5.106.0.tar.xz";
      sha256 = "1ccxkvrrm8762al7d4c8y4zrskc5cvbs48irq9ib5pjfmpazxbns";
      name = "qqc2-desktop-style-5.106.0.tar.xz";
    };
  };
  solid = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/solid-5.106.0.tar.xz";
      sha256 = "1bsqsandxllxynryvjm2r1fragxzjf9apjk9dc8za3hghnmcl6j7";
      name = "solid-5.106.0.tar.xz";
    };
  };
  sonnet = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/sonnet-5.106.0.tar.xz";
      sha256 = "1z8f507cd0ghwxxvazrzzi4yhv56r955k1nn8c4h1y42vnd43bfb";
      name = "sonnet-5.106.0.tar.xz";
    };
  };
  syndication = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/syndication-5.106.0.tar.xz";
      sha256 = "17zpspii7ng1z1pkfh82v66585mkjrpbrbh5d9gjjwqgf35ky3fh";
      name = "syndication-5.106.0.tar.xz";
    };
  };
  syntax-highlighting = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/syntax-highlighting-5.106.0.tar.xz";
      sha256 = "018wkf0xg3byzf297vd15fh5jnalv2myx7djx4vq67slpfiy706d";
      name = "syntax-highlighting-5.106.0.tar.xz";
    };
  };
  threadweaver = {
    version = "5.106.0";
    src = fetchurl {
      url = "${mirror}/stable/frameworks/5.106/threadweaver-5.106.0.tar.xz";
      sha256 = "1xhy2q5a5bjwl8vfy9k061vrq226g8bqxkrcp35acbkgl933chvq";
      name = "threadweaver-5.106.0.tar.xz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
}
