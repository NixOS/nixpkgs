# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.3";
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
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ar-4.4.3.tar.bz2";
    sha256 = "1gnrnkkmchfwjdc712fkh6apl17d2nmnyyliim8k935s5nx40469";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-bg-4.4.3.tar.bz2";
    sha256 = "1zqb07b77lpbk36xgz9s2hrxjwaayqcmp13apqnpbxdjfi98c40p";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ca-4.4.3.tar.bz2";
    sha256 = "1y4kp45mm2bqd7sh4p94q7z737n7d56sfca01l4k2z6if2mfdqyv";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-cs-4.4.3.tar.bz2";
    sha256 = "01drz8cxaqh6vf1pk6pp18bdv4a5imgc1ajsv6cybc2sa63wff3m";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-csb-4.4.3.tar.bz2";
    sha256 = "1slii5r0s7s8wgmh3j0lxk5k7crpqyn3cyn0shh3fycpi3dhazlh";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-da-4.4.3.tar.bz2";
    sha256 = "17kjf2np54kg0s7gimsf4mh93zjvvs2drasb4ayw9phkdcs4a5b0";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-de-4.4.3.tar.bz2";
    sha256 = "0v14qf47cvldxg2rlwgakxliamn04x77df48d7g1hzwapvd9s0dd";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-el-4.4.3.tar.bz2";
    sha256 = "03bf7lrm2bkxq2q0h18c4ksa3pbxr5yv9363z0396px4zy6srn3p";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-en_GB-4.4.3.tar.bz2";
    sha256 = "0jzvybpq9nnnw8cqp3izj7x804gd05q4mzjl8pxvv56s622zdda4";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-eo-4.4.3.tar.bz2";
    sha256 = "1br75zkyrl0imk0bnr4prcm4w4xmkg8qnjs2yn6842d8m4ffy2q0";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-es-4.4.3.tar.bz2";
    sha256 = "1vxjxgsvb3fr904nv6s84b0a0nbchv7599gfnirwbdklglbla85h";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-et-4.4.3.tar.bz2";
    sha256 = "0r6l1b1pfkry45g5wmii4d5ysalg9w8544dkbib374wjn9zm26qc";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-eu-4.4.3.tar.bz2";
    sha256 = "0rpdalv8bhmvv0cgf4wjdnlqamjqil7sl1brqv74p2dlhlsz03n7";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-fi-4.4.3.tar.bz2";
    sha256 = "1m5czzfmjg9gvw0jyfa875gb7h33yb179vgissddfjmmhap0yypn";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-fr-4.4.3.tar.bz2";
    sha256 = "1whk3a40cc2yiq7biql5klhl2k9h1bi3pilm0yskl0x6x8cdsn3d";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-fy-4.4.3.tar.bz2";
    sha256 = "1xwk1jqalj47iky3cda7z053jsihi0hf4k7sh2cdgvy50n5wj8bi";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ga-4.4.3.tar.bz2";
    sha256 = "0y3p8kj1fm88s5g7md6fwf3hlk5fshaywyw2l5bvx9vrhdv757f1";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-gl-4.4.3.tar.bz2";
    sha256 = "0j8f4185hq162d4xvk0qzv5drqz1sfx7k2pamqp9vf87js193m1v";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-gu-4.4.3.tar.bz2";
    sha256 = "141gdz79g2g13c36ci0pzk582s9kj7s47brzamidw683ndjvsarq";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-he-4.4.3.tar.bz2";
    sha256 = "0safk2vzpr3v1kbm236d4ayvqqa4i5zz8jppabr2zbak522sk6nf";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-hi-4.4.3.tar.bz2";
    sha256 = "08n1id22k46cnd8jkqczhxp33cz33bay1mkq1zqbwk4nxn9n5b42";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-hr-4.4.3.tar.bz2";
    sha256 = "061m5z4fnv7h67g05izdghrpa9bh0f3pk89s7wpk2w41pdpzk98j";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-hu-4.4.3.tar.bz2";
    sha256 = "00jk5ccq7ds9gcx4qb08i85cll9qs0wprw949412hbylwwj7c0qm";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-id-4.4.3.tar.bz2";
    sha256 = "0c64s38vzwjfdjanljspxqaishmw0c7qz7z2s4gc70bws02dz87b";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-is-4.4.3.tar.bz2";
    sha256 = "17kv9lkiy60kfk9v535fpnx3v2v4vvnjyk0qqp0nigyg2sa2ylhl";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-it-4.4.3.tar.bz2";
    sha256 = "17czl01vskisy5fsyk774rdsdrf86pihqqrf6r80flpgd5wf33ym";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ja-4.4.3.tar.bz2";
    sha256 = "0124xnkkwxdjfmpqbascqfsd3v82r2f4vjjp11yzp8fzfz41qqzz";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-kk-4.4.3.tar.bz2";
    sha256 = "1kyzmw0x7cvhf7bgryvk1c0sqg0cw6qnzalrky451brf82r5k4fk";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-km-4.4.3.tar.bz2";
    sha256 = "0jyc03zw15bynpjn1ddnb8xzjl2vkkf017yb5g5i5a5jxwp04ca4";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-kn-4.4.3.tar.bz2";
    sha256 = "09wkq79g7rayvv3khx3g8hmzqmlq7pa95wzvixyrdnh9fwk0mm36";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ko-4.4.3.tar.bz2";
    sha256 = "0dhkly119cgrmyil0c7zci77hf5w5k2pjaqgz9xx5g2k9jxf8f9q";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-lt-4.4.3.tar.bz2";
    sha256 = "1z4gimw4wdig1x0y8h780a2msdsy8rrpaqh8a5vpskjrx67y0pnh";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-lv-4.4.3.tar.bz2";
    sha256 = "1gfh2bamgbsxd042gjnw7x41qw6svw8dq6vz842lkkygdfplk679";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-mai-4.4.3.tar.bz2";
    sha256 = "0bx7wzqm2h3gsinpx0njsmb1x6s1jpj5v6cny5vrjawdm30zbxp4";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-mk-4.4.3.tar.bz2";
    sha256 = "0yjhi7v4xfbcxp6z8ycfxqixx2prmv6d05bvlaas4l83vc4i62w7";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ml-4.4.3.tar.bz2";
    sha256 = "1bd4bb5q70w6k5yqnx2ndrchi745jszih9mi9xsj6v6m8zsn285c";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-nb-4.4.3.tar.bz2";
    sha256 = "0l4wab6c5sx10a9scimbw4nsmfy58jm7rgrb94sv2v34awnkysji";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-nds-4.4.3.tar.bz2";
    sha256 = "0njih51wyj21dk2m7z2165w5ywk3v3w6zqdnvjby489q1laqi9hc";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-nl-4.4.3.tar.bz2";
    sha256 = "11hwijl2x8m9ianr5sniig1rqfdks7z72xaax9n922qf4i8v6n5g";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-nn-4.4.3.tar.bz2";
    sha256 = "1wzvaj5im4kwgwxlbig2pdckiijdks3za5ixjc00axk0zkf16604";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-pa-4.4.3.tar.bz2";
    sha256 = "1zdvzk49x9f1fn87sglw5hm2pfjplx94kxra0qyhvy7v899bmixq";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-pl-4.4.3.tar.bz2";
    sha256 = "0fwfc1h3iwmzl52b1wk1bpxghvy0a8ipp26c813jpv5pqnds777w";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-pt-4.4.3.tar.bz2";
    sha256 = "0ccswd7lvkpfd2hpzmlvg2dwylzaf1kp0r2dv080308cnji45j28";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-pt_BR-4.4.3.tar.bz2";
    sha256 = "1a2fwnlj9pcxjy9fkcciiry42fi7wpdkb5qhim5v1vg1j4ah6zz8";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ro-4.4.3.tar.bz2";
    sha256 = "1f3ikjg19g2lnbrwcryvi4pz0hdy4prq91jw2s1a8cadh3yjr0bz";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-ru-4.4.3.tar.bz2";
    sha256 = "0f888p973amz0nfahk48ayp20nc76f2rnxhdf4xr0y6rk3a5q3ah";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-si-4.4.3.tar.bz2";
    sha256 = "08yfm46abd58fralkyc7mfg20hmk34y5xpnqi09g2xys1ab630bq";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-sk-4.4.3.tar.bz2";
    sha256 = "1nnr8mwz24nlc0cy4jkwam7bvdk71vqd0w4ncfjbqi31p69bq12w";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-sl-4.4.3.tar.bz2";
    sha256 = "06j62vh78a32ygawvb81d5jsz8canw2w973cjay4qi104ibl8x7q";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-sr-4.4.3.tar.bz2";
    sha256 = "1yyrqdagfssclj0amw7hnsgdsm1ma3jx03m75kz1xz4dwx044b2q";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-sv-4.4.3.tar.bz2";
    sha256 = "1gynji087fk4iy0410qlh92j1z61mqafbkvw3gy6s82ava77i6i3";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-tg-4.4.3.tar.bz2";
    sha256 = "0vg1sfpyvsi81qaiqb0cln21dvvvck7zvbzyic7cb0028a3619wr";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-tr-4.4.3.tar.bz2";
    sha256 = "0lc8sj6lqidjrhhwipi98kkvc3y0bnn6d04j9dhf2z972bcfpfbp";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-uk-4.4.3.tar.bz2";
    sha256 = "1qkpd4qms5gx2lgmciwqbpdrvh251dlgrckzxxd3ch1z8ns2d3xa";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-wa-4.4.3.tar.bz2";
    sha256 = "1f8pm69dlx1wvn56km2skk1xm602jfk0984fzhqhpdkkmji8cijn";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-zh_CN-4.4.3.tar.bz2";
    sha256 = "0103wgjqnw542n1492ll7psmly84rxc7q68r6zmszmd2s6nbhlvm";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.3/src/kde-l10n/kde-l10n-zh_TW-4.4.3.tar.bz2";
    sha256 = "08bnljg956948gfm380dlqllj090bv1gpc0y2w7gpq3cd3mqd0xv";
  };

}
