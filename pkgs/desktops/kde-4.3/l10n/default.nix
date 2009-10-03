# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.3.1";
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
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ar-4.3.1.tar.bz2";
    sha256 = "0ynccwvlx61gy7sh4z3l9s21v6zaw41qh9krvc1m896v97qm9sxw";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-bg-4.3.1.tar.bz2";
    sha256 = "1wxrdwba3hsszbil1qz6kv9c72irhd2c4ys1lw67z7xg97s706g7";
  };

  bn_IN = deriv {
    lang = "bn_IN";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-bn_IN-4.3.1.tar.bz2";
    sha256 = "1znjkpnwibc57wd7vh6zrr2hbxg410akwmj6yyjz71w3r125nz9y";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ca-4.3.1.tar.bz2";
    sha256 = "1jvsl9gv9ksijfp1pfsvhnb7yjl7cdnvg9vzmz18a9r4wbah6w5m";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-cs-4.3.1.tar.bz2";
    sha256 = "01jwch5jklla5wrm1357nlsvnrajd4k7ynlgl7x15dazgzff5kmw";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-csb-4.3.1.tar.bz2";
    sha256 = "0zkd3z716hxma4pdp21vziv113rja5ws65yi4ding6jkm1sxxlyr";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-da-4.3.1.tar.bz2";
    sha256 = "06ihh22qig2prz15gc157l05vgcd2n1flkk84nclabi676yngddj";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-de-4.3.1.tar.bz2";
    sha256 = "1dj5s0vdcq22hnhjx3d8hwfnh2j32v1cf7h8xp18p5iisv2g9k4n";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-el-4.3.1.tar.bz2";
    sha256 = "0hb1ccdwsxch9sd57q0w8gdqszh673flwayfwl6ss5gb5h40p98i";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-en_GB-4.3.1.tar.bz2";
    sha256 = "0d73jnvl49z499phrxcarqm8vdiv58pyinw4vlz64iic7h5izf6i";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-es-4.3.1.tar.bz2";
    sha256 = "1xgnj4kwjmic8xfdxz5nmq8pv463k4hwhagjyp8w4y7nc7y80vvx";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-et-4.3.1.tar.bz2";
    sha256 = "0j3c3k0wgrkpr2m35m8ms2in0p6a3cmhzs4mp0i4r4k1xqx3fj0v";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-eu-4.3.1.tar.bz2";
    sha256 = "0z5yvjcdjx0968mslrvsqwxa1lxhb14ba0ydb79dxr9v227jw606";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-fi-4.3.1.tar.bz2";
    sha256 = "10wjm45i8amzacrs2px53vicyqdi3j8p31jbvdf08mz1fj797rxa";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-fr-4.3.1.tar.bz2";
    sha256 = "0c38299lwh6qj110knhlk5xlaxqxn8mpsxnsc4f9j04hkgwywim1";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ga-4.3.1.tar.bz2";
    sha256 = "08d8mxlr9f302qw6zqynhkmjpyinbaqz3k42fksn2lmp0ddc3123";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-gl-4.3.1.tar.bz2";
    sha256 = "1vxh3wkbrrrwxz24v3g32265fjlxpi2i0347xf8166xvrfd46m5n";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-gu-4.3.1.tar.bz2";
    sha256 = "0x1z463dd9z6jd80sc46kz70j25rwsfqgfkkw7nc9r01p74gzgca";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-he-4.3.1.tar.bz2";
    sha256 = "01xkdwcwblfmjhm6k1addvvlflssiin2pliplc2n1y2kwcpqirn5";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-hi-4.3.1.tar.bz2";
    sha256 = "1cll6mlr84hq2ms0dp3pnpb1j4mk0h6l72b87q8q6mixyxsnbkcw";
  };

  hne = deriv {
    lang = "hne";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-hne-4.3.1.tar.bz2";
    sha256 = "1cyp8hskqb4690bhmlzh06zkwi9wkjr2m84ksxnr80qiyqq4glbz";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-hr-4.3.1.tar.bz2";
    sha256 = "1klli9gkfqzv8zh8mwd3rfdj2jaqiz85mvsh0w17sgsdi2v895np";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-hu-4.3.1.tar.bz2";
    sha256 = "1812scv24yh02nnyvbfysmk63d07r8d6fxk28468jppy1d41nba8";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-is-4.3.1.tar.bz2";
    sha256 = "03m4l3q1zqim2gvfanxhm15f66ywbf79w68912ds39br46c78m0b";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-it-4.3.1.tar.bz2";
    sha256 = "1f2fqamwwd2cy8ahqjks25n45qhp9yl2gb8sq18f505mdqwf2v7i";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ja-4.3.1.tar.bz2";
    sha256 = "0pcrhkxbvdbc3mizmwx49sy46vrrvjd24hhwshdxmjrraxjkdz8c";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-kk-4.3.1.tar.bz2";
    sha256 = "166divf5myxcav0kgnfqnnkn551zmzn3mh1b02wsxgd24fqvwhwy";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-km-4.3.1.tar.bz2";
    sha256 = "0yvmhpk31afs6jg19gx9gws8b7y9g9kdxx9vy50x97xa5gzqmc04";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-kn-4.3.1.tar.bz2";
    sha256 = "0hpn8vblr147wrglrasyfm49018ai1w3m13q7wws6pjrqrsly808";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ko-4.3.1.tar.bz2";
    sha256 = "1gcq9cf13xa59f10w7hm3k927s3kndr1g4lnb4bpdjg397hzywpz";
  };

  ku = deriv {
    lang = "ku";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ku-4.3.1.tar.bz2";
    sha256 = "111ffadf78ag0y7d1dv05zsrcbln5g5j9f9dzrlg7v1k72hgmmrf";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-lt-4.3.1.tar.bz2";
    sha256 = "0whvg9g779q2wjxcf4wczngd40yd9a92z1bhp1ik6jlaks7fl82p";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-lv-4.3.1.tar.bz2";
    sha256 = "09bx190ggmq9ilwiiz4rradnlq6i3j42s3634vs5x69wjdmz4r03";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-mai-4.3.1.tar.bz2";
    sha256 = "1mx4fwk38qgvzxmr4f8nl8jfl2x3v9ai8iwax81pms32fcm10qyb";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-mk-4.3.1.tar.bz2";
    sha256 = "1zlbmrywh286v9n1m9wpb9kickc598dz2xx9676dhjsx34gap2gp";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ml-4.3.1.tar.bz2";
    sha256 = "0vhgafiy65dk3gj6ivagcwdfw9hr653nxj7nll1x9q8b34252pnv";
  };

  mr = deriv {
    lang = "mr";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-mr-4.3.1.tar.bz2";
    sha256 = "0rhpzi2pg5qr8kfpsxjj22ljv1wrl13xxpqgimbyzm3d93dsp6jw";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-nb-4.3.1.tar.bz2";
    sha256 = "00s5f9sabxk4n8zr1v8vyra54dx8460qq2nf57q03fmi09pfmfpr";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-nds-4.3.1.tar.bz2";
    sha256 = "12yhh5pw1kqpk06h1blli36nb45h3jk6crymk7crwhg1yf59cczb";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-nl-4.3.1.tar.bz2";
    sha256 = "0c1mbj0sbx5901j6sfjbbjv7izii5vv8m9zlmligbxcan3c4cyfp";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-nn-4.3.1.tar.bz2";
    sha256 = "1648k16127vl5fslcy3pb0yv9m8hz1l7s1krabbpwy3kpaxv37lm";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-pa-4.3.1.tar.bz2";
    sha256 = "1z8dbc2fn2ikgaybk9fd438qd0jkyw7l4rkvs5xk9mxrj0ypf3jz";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-pl-4.3.1.tar.bz2";
    sha256 = "0abiabl33azv1d3ri62p909yv5n1awyhv83s2w44sqfmgb98vfjv";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-pt-4.3.1.tar.bz2";
    sha256 = "009jsm6jj5ylickxjxnnaxm70qhq5nrfd8ascyc75qhvc4vg6y8x";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-pt_BR-4.3.1.tar.bz2";
    sha256 = "0wz14j3ii4yjkf1n7138f6kklz5rbvk18gy8j8vikgmy71q98fcf";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ro-4.3.1.tar.bz2";
    sha256 = "0lm39bhfcxwn2kz6m2hqnrazmvi0aylmm2y21z72gfh7vfwkxhlq";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ru-4.3.1.tar.bz2";
    sha256 = "1ls23wbwrwav3vi3wc13svxghbgn330b6h032nni0vl8i58b7hhf";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-sk-4.3.1.tar.bz2";
    sha256 = "07p4jxkic2ksp5c3qjmm4gpnypnbgka1xdbys5ng681l58x3r3cl";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-sl-4.3.1.tar.bz2";
    sha256 = "0yqwkpv9r2j1mhynbnjp0cyvffp465681l4rm14n114128rhgq1d";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-sr-4.3.1.tar.bz2";
    sha256 = "1i4yxij7syhbbq0yx6fix6757vcj66faqzz1zalwm9x1a2qqxjlj";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-sv-4.3.1.tar.bz2";
    sha256 = "0i9wc6s5x0xswh4kqhfdwiiahrgz81469finrvdq6hpdsc9ajxww";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-tg-4.3.1.tar.bz2";
    sha256 = "0g90k909k4mkph9wl3z55h5kr41q477biy9zgk5z9rad3sa7sb3b";
  };

  th = deriv {
    lang = "th";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-th-4.3.1.tar.bz2";
    sha256 = "1sjsc0mlzmj7xgnhig1l0l5qgl6j7i4bsfnkaxp036kfsg53n1x1";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-tr-4.3.1.tar.bz2";
    sha256 = "11immm9i6a7w1308d7mn8wizykxp6hh36wycj8jay74yig8mr5j5";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-uk-4.3.1.tar.bz2";
    sha256 = "08cgmhgmdr6v7syjpd2vzwf8mq1fh2gdnnwdj20pg6kbg4niyrpv";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-wa-4.3.1.tar.bz2";
    sha256 = "12qf17bgfd7gdqm6cqblh4jv8g0zj4wa57ny8yjg04y74xsivj93";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-zh_CN-4.3.1.tar.bz2";
    sha256 = "0x7l5scf1ah40fnfivrb1sgqav8la41nb06vrzd0q73p6hwzdd1f";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-zh_TW-4.3.1.tar.bz2";
    sha256 = "00hx9c13gfgkd2cqg5iaf3q652kz4yjb9w0wxw32ksmnhzl6bjkg";
  };

}
