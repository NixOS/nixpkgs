# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.0";
    src = fetchurl {
      url = attr.url;
      sha256 = attr.sha256;
    };
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
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ar-4.4.0.tar.bz2";
    sha256 = "0a4s8xhbbmchhdsf139dvl9z27rkzjz2xf8c6wj95mc9fi1mzrsh";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-bg-4.4.0.tar.bz2";
    sha256 = "00xhn5vdsxv2q63r8944ik51xilzi5q69wpj2358nn6xz5pwjq7z";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ca-4.4.0.tar.bz2";
    sha256 = "1r2b5gh13wim3xpwbs17nf3llkfb5v143jcrgwz005l9fhi0mzv2";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-cs-4.4.0.tar.bz2";
    sha256 = "1wbwk8g2661sygk7jjnsjfnmzv1zl1y6509qw6bkdikn3xd9v0wk";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-csb-4.4.0.tar.bz2";
    sha256 = "1vi6a4y1kgi1dlzzvvskdgcal1s0sfz4nbk46y92l3gnlmmkfzd1";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-da-4.4.0.tar.bz2";
    sha256 = "1yxv76fvla1ba7v5zgbxsq0v6qfbcx96k2znaqi6055zzrymhf8k";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-de-4.4.0.tar.bz2";
    sha256 = "1kgv76vba5dhqhhg24hjl43kf2pd80h6plpf17p547k071xpfnw2";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-el-4.4.0.tar.bz2";
    sha256 = "1hw652vr4d5djsxgy7hp0kjshg55zxdqski5gg2haj2wzr7y5l6r";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-en_GB-4.4.0.tar.bz2";
    sha256 = "11xgnpvvarkji7lgwvnhxf1jz4819881hpn1532w8xrynj9nky21";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-eo-4.4.0.tar.bz2";
    sha256 = "1mdgm2fr0pqi2g4p5jpwgd1jrmmzi1qqxfna0dasfmy2nqsqf2bz";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-es-4.4.0.tar.bz2";
    sha256 = "0gaxnriw699mdp4j50jf8g46yaw08rzm4gp4211ikd4hs6w1vz12";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-et-4.4.0.tar.bz2";
    sha256 = "1ds404baq6al0240czlvvz52dlsl628kam0lamfw4b4fbkp7khdw";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-eu-4.4.0.tar.bz2";
    sha256 = "1knh3rz1yqwsz6xjrs4xn80p2kl0ydjhwv6rgd3ll6gqqq274rnf";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-fi-4.4.0.tar.bz2";
    sha256 = "1x2d5wlyvg3m8dj4prmfy77qg0674b3xlj35q5l8avp2knzsib1s";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-fr-4.4.0.tar.bz2";
    sha256 = "0ccyw7gnv9dcsb8cgydmrn675w3dhr012zm0zyxxv9h2mgaia5kj";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-fy-4.4.0.tar.bz2";
    sha256 = "0kjgxq90ng410zp19b2j3b9k5rz9ad1g1zgxv8xmvjfvdzj5ycs4";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ga-4.4.0.tar.bz2";
    sha256 = "1a7dyn1ly6n6gnxh5kvwim5yf1mj4ynlj6jlmgfxki4y6mlqhdp5";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-gl-4.4.0.tar.bz2";
    sha256 = "09w81016dkhmm32jbgcfmy05895kbfj0f7s26g57ahnscfr11sz3";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-gu-4.4.0.tar.bz2";
    sha256 = "0rgq789mr0phwm7xxwkazkqp1xqikijxan3qvznb3yn6nf4qbgqk";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-he-4.4.0.tar.bz2";
    sha256 = "0l18f6qjhkm9bjd8dv4nr3bv895s2jp4zch19pysxxigqpxhd2y6";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-hi-4.4.0.tar.bz2";
    sha256 = "16ah2g37hglhgsl48xc46xig0aa5aka7lwzfkmchnb9cn6jn9lqr";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-hr-4.4.0.tar.bz2";
    sha256 = "1p46zbf98lwh50gs5lb926wgkx3lxwcirnnax970d1xk94ym4c03";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-hu-4.4.0.tar.bz2";
    sha256 = "1xrsw13acvjw9s1qfwhnk8sr2bzj8jn3q2bkqpkwiycp8xsc34qw";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-id-4.4.0.tar.bz2";
    sha256 = "0nln6zminkq2b23wbldgdfc0hjkzl4lh8l86hp5bs2xyhjq9sspj";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-is-4.4.0.tar.bz2";
    sha256 = "0zrdirkgj5x63xp5w45f5ddl4w8fyxfqzw77pf7cj0ciczmaxr1q";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-it-4.4.0.tar.bz2";
    sha256 = "1dmnn62qp6ysxhxjx55pa0dz9qa4anmi3bnnncypq3sxbpc3wili";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ja-4.4.0.tar.bz2";
    sha256 = "0dq7h87gw87vb6d4ld9dvn0msjrzw8v7ns44gsfb7ww21hmghivb";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-kk-4.4.0.tar.bz2";
    sha256 = "0ynahrjal7xc9l5wdcihb4vjbgsf3sxpraavmdii902jsjqnwi74";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-km-4.4.0.tar.bz2";
    sha256 = "1zb2p32frmx96hvzh9ln3k6v59pps55g890f919559zk7smglwgb";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-kn-4.4.0.tar.bz2";
    sha256 = "0xbpw1z8j73psj0bhyry9srbpshy8wz4l61dqdgcdb7yczf865jl";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ko-4.4.0.tar.bz2";
    sha256 = "1py0x86sz291as581vzyf1mk38p50jqwcbknc44vg98r6b83hf4m";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-lt-4.4.0.tar.bz2";
    sha256 = "00vax8lv0z6gjrsd4j4fw6h5ica3gwwrflihkws7cs94cbgjchd3";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-lv-4.4.0.tar.bz2";
    sha256 = "1savmh000g07yg30j5p6jfvgv3aj96jdf8nnjbw26rvh12vi3caa";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-mai-4.4.0.tar.bz2";
    sha256 = "1lycsmk047k7v0yknhc826xgycsfx7pjnxg693fk4prh75nj0v3k";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-mk-4.4.0.tar.bz2";
    sha256 = "0fglnhrwrsyxf9zq3ckd6kdqh8m6gcqw2kh95h8qc8fl8gxskmn9";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ml-4.4.0.tar.bz2";
    sha256 = "0ivyy3ixj2z9j6np3vcapazgjs4nz0mxxlx74vp9fr9bskka9f4y";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-nb-4.4.0.tar.bz2";
    sha256 = "1mmccv5kpfl5p31jymmhb27x5s6xj53kps7n6nfj3r7k6k66iszi";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-nds-4.4.0.tar.bz2";
    sha256 = "090gz9jzsjmwr01ms98ilcrh97jh0ydprx5dg6ra5sd27h53qg2p";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-nl-4.4.0.tar.bz2";
    sha256 = "19r76d56vbmhcg340gsxx27la9j5y5lp1f736j4c0bgpwx4ryagk";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-nn-4.4.0.tar.bz2";
    sha256 = "1cmq22mc46g9nh3bmzw4b62alkk0i2hib9hg9vammpdmscxqlapl";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-pa-4.4.0.tar.bz2";
    sha256 = "0ngqnbxavj1r92njymx645a2rfdp7xmsrhd2n0glhix4x3lc7k1a";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-pl-4.4.0.tar.bz2";
    sha256 = "111zcsqw42h9pyxr82mkh5jkckv5803n37731yh7zphsqdrr0fz4";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-pt-4.4.0.tar.bz2";
    sha256 = "15ad2qp5667cvfg6b39d37nd4hashfrn9448awlwr4vkk6fkwfr6";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-pt_BR-4.4.0.tar.bz2";
    sha256 = "1yax60mipr60ixwwv1wqq31qbc1pzq193fywqsjsjhp2vycnslsq";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ro-4.4.0.tar.bz2";
    sha256 = "19a77nsk3y0abr9csklwb3q1fbyy2gqfvxa4yhkba54055h55sfq";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-ru-4.4.0.tar.bz2";
    sha256 = "0d1vsvxqp9a8w0mpsw99hsv3am6iga2v5v2zyizcm4vd1997ycn8";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-si-4.4.0.tar.bz2";
    sha256 = "1gm8kx2qqwgaj7wsjwpvhiqiw0aw3ics7l9mp25ai04vs140axfq";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-sk-4.4.0.tar.bz2";
    sha256 = "11wq3z3nrh0am477izs4w0fgpzq7ha106286na3p2z7izzfyfh0k";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-sl-4.4.0.tar.bz2";
    sha256 = "092f7sy5dn0zngvsvifrapb6k40xqcj14qrq0bf2vqlf0a18q78i";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-sr-4.4.0.tar.bz2";
    sha256 = "0p7nnnzsm83jajwk8f080p0wkqybsnh17zim9g31yiji0d44bqbw";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-sv-4.4.0.tar.bz2";
    sha256 = "1h2aip645l50pxadv5sa8gamd9wdvzl6yahgmw81k9fqkh48qqk6";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-tg-4.4.0.tar.bz2";
    sha256 = "10izjnp71bgmawjhslwqzixppzkfxi9gj52r705k2y317z548lgl";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-tr-4.4.0.tar.bz2";
    sha256 = "11ccp03yscad0drd11mlvsyw9b72sjh076vlbfi6j97bnvm1cgrx";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-uk-4.4.0.tar.bz2";
    sha256 = "18q2q4s2hv2bzxj7hxl5grjnns9hjsqikybq3icp7pixsdgqadxd";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-wa-4.4.0.tar.bz2";
    sha256 = "13zmfw2v2rqqi6mpk8zhkniyvbji6c7d7njkm87wlifz1sz4svnk";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-zh_CN-4.4.0.tar.bz2";
    sha256 = "0pbgy20434365sywzq58syi2bsqh6pvdb8adg1lmaqfy5na60s9z";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.0/src/kde-l10n/kde-l10n-zh_TW-4.4.0.tar.bz2";
    sha256 = "190r44x834c0hrbilvx5x0901jm6dqpmsc76gxdbvfkq563x0yr9";
  };

}
