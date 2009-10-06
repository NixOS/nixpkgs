# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.3.2";
    src = fetchurl {
      url = attr.url;
      sha256 = attr.sha256;
    };
    includeAllQtDirs=true;
    buildInputs = [ cmake qt4 perl gettext kdelibs automoc4 phonon ];
    cmakeFlagsArray = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
    meta = {
      description = "KDE l10n for ${attr.lang}";
      license = "GPL";
      homepage = http://www.kde.org;
    };
  };

in
{

  ar = deriv {
    lang = "ar";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ar-4.3.2.tar.bz2";
    sha256 = "14anj03y901n2ifpalbwsn5qbwp7xxwflsbkaymlv319hsrndxsr";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-bg-4.3.2.tar.bz2";
    sha256 = "0wpvxb8b1pab56m287h5jmix15k0fjaf6qsyiy7ndlir80bk5myc";
  };

  bn_IN = deriv {
    lang = "bn_IN";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-bn_IN-4.3.2.tar.bz2";
    sha256 = "1vwairx5x9xibzk04chrnzljpni7q1q88jfg3anh76jf662ak4zx";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ca-4.3.2.tar.bz2";
    sha256 = "0rs1zi8wjmdls2cjspd9c5mwsl99ipv2jcrmiar1nppdy4bwmb3h";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-cs-4.3.2.tar.bz2";
    sha256 = "0bhwm4w01ajq3kqnx6rri8mamz881vs111yq9bhq5fbiwwl59fwj";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-csb-4.3.2.tar.bz2";
    sha256 = "0r1vwf8g4bl7l1cy0knln74l5x5b05xmbdf3k33f7hmzkhyi6140";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-da-4.3.2.tar.bz2";
    sha256 = "08g6lw052jh9k7za55qq7wjw0l7bdhz9pxnlhakjnx701bkyg3ia";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-de-4.3.2.tar.bz2";
    sha256 = "1jnx2hm0b1gzj8jbzmkg0ckwcmqa6v6ab3iq4qwan1ik0nsgjim9";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-el-4.3.2.tar.bz2";
    sha256 = "1kn1d9rsdanr41yay47ik00dlhr4qzdz025hsdf3jazr0vp2iqnq";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-en_GB-4.3.2.tar.bz2";
    sha256 = "031kxps99h6wqwffqdlbhpbcp3v8ccv1zg7qxg8z02dbs3anydgy";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-es-4.3.2.tar.bz2";
    sha256 = "0v5fcyhqjfi9204zxpyipzp1lj9dql8rsq55jzxcpj4jhc5xmmp7";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-et-4.3.2.tar.bz2";
    sha256 = "0zl7391grsh6iac5z18vxpj9yal3iv9l3sdkxsfx1jrw4x8n086p";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-eu-4.3.2.tar.bz2";
    sha256 = "1ams8gp4nx1gi54jb68r898j90jfxzgz6r16yn5gm6b3cn45g4wp";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-fi-4.3.2.tar.bz2";
    sha256 = "0a16zyd0r30f0wl5vp8xcgci1b09rmlizscj1f22c91ydwl2dxvw";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-fr-4.3.2.tar.bz2";
    sha256 = "190cyxdhi8w1mqkaan476ddabn24lkf4r4ndpbyrqa9nl4ws5s74";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-fy-4.3.2.tar.bz2";
    sha256 = "07g6yz3kzsbwjx1b624x8q1bwhb26jh7zw38vxd25jhj2vk0gfal";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ga-4.3.2.tar.bz2";
    sha256 = "0ljjzpn63zp7fl81kf278dd3xj73q6plfdq7l62ax9ndnyppm11n";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-gl-4.3.2.tar.bz2";
    sha256 = "1r8nz9kl1qxqkvgp1hbmaxrm0vyxq0j3wllgz3q0fq4540n2bm9b";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-gu-4.3.2.tar.bz2";
    sha256 = "1iyfw0ydfjq3004ww58f3bckk1hm3546hqq4i327025q66k68bbh";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-he-4.3.2.tar.bz2";
    sha256 = "0ba130q9ajb3vj6hsyj8p72hmyzps97ih31g0k34v9aya0sv9phb";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-hi-4.3.2.tar.bz2";
    sha256 = "0bjvrmi609m6g96jycv62v1p7hni29l30vffqq7bi9vb1y9wpjn8";
  };

  hne = deriv {
    lang = "hne";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-hne-4.3.2.tar.bz2";
    sha256 = "1fsfqj0dddw25jrx19bjx9f1dc1gsd1sda6rxiqsmn2km3h75dbv";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-hr-4.3.2.tar.bz2";
    sha256 = "1q0aajrgfbcr2z7ifa50v2hvqffgdiq3pv43pdkzhnn80r0s3i7x";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-hu-4.3.2.tar.bz2";
    sha256 = "0six6ppgxlr598b66x3c7wwx8ax3f2p31ghsq58p96hjaa5j7kfp";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-is-4.3.2.tar.bz2";
    sha256 = "01r15rvs4z08m67pfpp8p1118k3sdnjpb82w3lbhss15m4wapa4n";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-it-4.3.2.tar.bz2";
    sha256 = "128kwj9n5v3zl42hf311j6d546lxawniizm6yvinqydlv77zbk4z";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ja-4.3.2.tar.bz2";
    sha256 = "0nza3jlzkxn188ycfw3kcrkz2kfqywklmmi7cvqcipa9hkbzaijb";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-kk-4.3.2.tar.bz2";
    sha256 = "1p5ayp65my82cndl6h9bardhgfbcfa3yrh6n6ylsm79g0ryi9a67";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-km-4.3.2.tar.bz2";
    sha256 = "12dyyjx5j7xx00c46c3zfiklhvgjhng15gdp4ps44y9viq6d1yyr";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-kn-4.3.2.tar.bz2";
    sha256 = "11pp6yyqj1g9ykl5ivv88qbfy5ywxxaafgh6xx132cwsq7bfsdzj";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ko-4.3.2.tar.bz2";
    sha256 = "1x4jv5b4h8rsaaikp5v8sppwx6gwbvi8g0mq2p5h21mwrcsm4zkl";
  };

  ku = deriv {
    lang = "ku";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ku-4.3.2.tar.bz2";
    sha256 = "0rdmykh0l3zchnshcgck4vrz5mhzjhpljdczhmksalf6ql2ix9w9";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-lt-4.3.2.tar.bz2";
    sha256 = "19fcnxjbndmk26hzyjf9kpkhksbly80hvlpx4drz54yv4l6frppd";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-lv-4.3.2.tar.bz2";
    sha256 = "0ag6sfm0pskw2lr8ia67zn9mlli1wfrzla83a9sp7yybs8fasgwm";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-mai-4.3.2.tar.bz2";
    sha256 = "0x5gjxwxsv3n0qcspf7575jymhqvvwgfl07zhxqh8ck8mc6vl7fj";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-mk-4.3.2.tar.bz2";
    sha256 = "1fqf9a22cdv9d4mlgw5czy86bcwar787m8c6kxfjl7qkwdzdi95p";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ml-4.3.2.tar.bz2";
    sha256 = "0y97dfn0zgpwzvyp5jqfqji42k8m3ill2sr1fclc7dhy5rs5lsgz";
  };

  mr = deriv {
    lang = "mr";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-mr-4.3.2.tar.bz2";
    sha256 = "18hfwz5wyzx88lzdx8x77bz27qzrzgv2hnmlhvygrhxdy664094a";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-nb-4.3.2.tar.bz2";
    sha256 = "179mr40l0z91r9whxrqwlh6phm3dl0w8s4mdnv2d195yj82k600n";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-nds-4.3.2.tar.bz2";
    sha256 = "0n0g47s4qyjlwpbi92by8158cz9cw440yiv4abnq63ncpwbwl36h";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-nl-4.3.2.tar.bz2";
    sha256 = "1frirs4zqmr06ixdanx6iyanarfpyp62qn991l29473ibxddxd7l";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-nn-4.3.2.tar.bz2";
    sha256 = "0wffm0ysib41ris2l73h51wv5d8nn7j9hqrrm544lh2l57q2xmvj";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-pa-4.3.2.tar.bz2";
    sha256 = "0ch8975g0sv0fwndg2x2gfj409986q731h0w05rlx7h7g0pvpk4x";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-pl-4.3.2.tar.bz2";
    sha256 = "1p45ld5q8vm5w4ibj9zzrf8w3wyc05bv0i5c2m6qjk1pns7j46w3";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-pt-4.3.2.tar.bz2";
    sha256 = "1nifiq0qd2rj7y3idgr5748zdy0gnsvfmvblzjhxv4krzl8hvppx";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-pt_BR-4.3.2.tar.bz2";
    sha256 = "0f702iwma12zxvqfc04sy3b8nipiscnzr66mm8kgycjzj586xwng";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ro-4.3.2.tar.bz2";
    sha256 = "0v7zm8lvqbla3sn7sc7v4h2k1g3q182yn65hniraxpmz7driixq6";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-ru-4.3.2.tar.bz2";
    sha256 = "1fcz5ga4q6c54x345lnpjf3yfcrp5m8zdk82gl1i9b060mdmkkck";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-sk-4.3.2.tar.bz2";
    sha256 = "1rarx33ybbmawapyx2mx391snfc5sqgyn1k8czvbs9ia614mi7s9";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-sl-4.3.2.tar.bz2";
    sha256 = "02h8011ibq68b9dq12wzcylnz78959c9yjzkglilkdybigq37n2v";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-sr-4.3.2.tar.bz2";
    sha256 = "01lcjdc758qn6sbzcs55l300f9cjp722gy5zjqw2dg3gjgi4nbs5";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-sv-4.3.2.tar.bz2";
    sha256 = "0v0aq3j2m2sar8ksyrkvky3q8yik4rywjadyq7faz5nwmab68w5n";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-tg-4.3.2.tar.bz2";
    sha256 = "1108sjdl19v4fi0dizfkfkgrmv6z07b90qb52q7qs3nn5f3rdg37";
  };

  th = deriv {
    lang = "th";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-th-4.3.2.tar.bz2";
    sha256 = "1krg0xqr5pdc5scw1v7jqmnf88gysbs2066jlj2vrf81zzrppl6n";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-tr-4.3.2.tar.bz2";
    sha256 = "1fa7rx87mm62winh1kd1ddl3gd6r519wj6pnwm50m2bzvrzfqdp3";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-uk-4.3.2.tar.bz2";
    sha256 = "0qam7pdcwffqlrmmmcz871nmanrbcqsfgqgdcmwg49d1vnj22mw5";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-wa-4.3.2.tar.bz2";
    sha256 = "08b3l54nnpdxhk7r50qmhmz2z102dq1020vq1lfmzps9cm62zmdj";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-zh_CN-4.3.2.tar.bz2";
    sha256 = "1x5rb1m7pbzx2jcd9zjhmxc554zvw6njm3cz1mbfbjhimlkvs72m";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.3.2/src/kde-l10n/kde-l10n-zh_TW-4.3.2.tar.bz2";
    sha256 = "0yn31l6rqqwqqdqss1pir82wphgnbs9qljzz628qipj45kdb75zn";
  };

}
