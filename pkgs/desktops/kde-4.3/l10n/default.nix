# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.3.3";
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
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ar-4.3.3.tar.bz2";
    sha256 = "0js4w2lgrffszg8xvgvvjd0ql41s8bfd4k8arzg0ym4rinsghb6f";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-bg-4.3.3.tar.bz2";
    sha256 = "1ys5f4rsvkm8f8dzyfka51rpkj02qrd3j4mcccsp963mgw9s12lk";
  };

  bn_IN = deriv {
    lang = "bn_IN";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-bn_IN-4.3.3.tar.bz2";
    sha256 = "1mf260w44i9267rdvvi26lj7qhywndhm66sbrsgic06gibmb3g45";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ca-4.3.3.tar.bz2";
    sha256 = "0xqdiv3sydbmncfh2sh53dqqhi205mdbq6iphinbzsr09xjcrqr3";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-cs-4.3.3.tar.bz2";
    sha256 = "0wb2ld2shjvyglajqip0s91q8y9sry6a3jwmr3g221gh6xz49dil";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-csb-4.3.3.tar.bz2";
    sha256 = "1q65365mqsrjg7j59s1dkx03m4hmwq45aa0yzkw5np8sgvf7f65z";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-da-4.3.3.tar.bz2";
    sha256 = "0s649zxpqcigpj3yar48liaf5jcmb3m2q0azfm9cwgkvmz9gd1nz";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-de-4.3.3.tar.bz2";
    sha256 = "1p4lz80myhrq7gq1gmpfhlw9i32ca0s4z7gni9rlsv5dhsbpmcsf";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-el-4.3.3.tar.bz2";
    sha256 = "01ym4yxdh2xghwc6mngs0iyw8idvmv3c4k6lkf9hasbkcr77s0dn";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-en_GB-4.3.3.tar.bz2";
    sha256 = "074is29a0h69ypk82s051f037aqcpflnaapwlccrz24x2hncw3zb";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-es-4.3.3.tar.bz2";
    sha256 = "1ygx2cyvgfz09i8x9wpynlaisvxv70n5p9r0hq72yypjxd1nqixb";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-et-4.3.3.tar.bz2";
    sha256 = "0yxvq1ggbqvrm45ljriibnz9s2zarszyk8wxjb1zsxlqs34ym02h";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-eu-4.3.3.tar.bz2";
    sha256 = "1x6r31s0zyxi5sdnfr5ldbvhfdbm5fcgfqxxz8x6sfm4zrpc8mhv";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-fi-4.3.3.tar.bz2";
    sha256 = "0wky41anl3p3ml0rccg9153s442mxncwzp784qpczlczrihg7sly";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-fr-4.3.3.tar.bz2";
    sha256 = "0mvsgyrf15yr4g24hfmiis54i68byyq35x09j0hrsn79z2wszgba";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-fy-4.3.3.tar.bz2";
    sha256 = "1c03w0ac9q3fxgjfyw1iq5lcq0n6hr8k8mpn7b3zr9rrvfdsldx5";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ga-4.3.3.tar.bz2";
    sha256 = "16032253hs5ikhi6f8j1l4lyy739kpks8qqmh205xxcx5fha9xjh";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-gl-4.3.3.tar.bz2";
    sha256 = "0d6j4ln5xz1m4r67ldc7byi4yd0p2gbwq7xpms36yrpyg1zx7r93";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-gu-4.3.3.tar.bz2";
    sha256 = "12cgplf9z0lsqslnwjbcbzkkz4g37n6h579gdcj3cs8gfmxja1mj";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-he-4.3.3.tar.bz2";
    sha256 = "0izvz3zry36ypbqn34gx68z3hwik0dmykhbgnhm0xhcapjjhq95r";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-hi-4.3.3.tar.bz2";
    sha256 = "1pqplq1b6vv60z6nwigiymh2n7gwhwhpjnkq84dml7p1jxabwckj";
  };

  hne = deriv {
    lang = "hne";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-hne-4.3.3.tar.bz2";
    sha256 = "17hkpx4adb3j7vzfij5dc3imqxgd76gpa3vknwmj1d7znzhf484c";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-hr-4.3.3.tar.bz2";
    sha256 = "0kciza7zbxv6gr0hk1hpg0fcm5v0anw3p3bzsmaj8svsymkvqkmr";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-hu-4.3.3.tar.bz2";
    sha256 = "1m290f1aw8rq2nmybi2dd5xbdyv50d5ma29jjc55i7cqjbh9vn9a";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-is-4.3.3.tar.bz2";
    sha256 = "1pjbi3a7hskgg3wd43nfddjjhnwy4r824zl6gdxrc42x8j8gh5r0";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-it-4.3.3.tar.bz2";
    sha256 = "1p9njh83k0zdczwyzilxfv50nw31mpdh466yid5y9973b6chbfzb";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ja-4.3.3.tar.bz2";
    sha256 = "07p3rg1iysgrpz13ac81gvqi26syyfwc0568gr3plk40xnkvs0bl";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-kk-4.3.3.tar.bz2";
    sha256 = "0bpr89798kfs9g59pq6yl5zvzdranlk6kzxpiqxzdrw65rj1r2fy";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-km-4.3.3.tar.bz2";
    sha256 = "0niifkgrqqwdaq1fcgck8v9lj8x8facp3zpxjzmf04cbr70wjy3b";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-kn-4.3.3.tar.bz2";
    sha256 = "0f9ksq1540bmjy57b2civ44javniqn4xvkmg8411kwh50ccx7qby";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ko-4.3.3.tar.bz2";
    sha256 = "03n4ifhh5ki9i9dhdzzqypg7iz7h7fdnanbv76v3nhklbkdw5aap";
  };

  ku = deriv {
    lang = "ku";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ku-4.3.3.tar.bz2";
    sha256 = "0mbjy88m57sljw12lman98bb60iv528qw223hl2rwi5kpjbzbf4a";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-lt-4.3.3.tar.bz2";
    sha256 = "0xwbqla7vqnbmpj0pk3p6lx0isfcyqximxzrh28pajgjrdq9q441";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-lv-4.3.3.tar.bz2";
    sha256 = "16jf1ci6v1n8b7sl7dadv5j3axjmicdrfm1d390bs1yqgv43g26a";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-mai-4.3.3.tar.bz2";
    sha256 = "1mir9yxqb6j52aippjhz2s8z4ya8gnram8bw09bfxlg90ws2q09c";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-mk-4.3.3.tar.bz2";
    sha256 = "0j4h3xaqsl3v7j5lf8n49w5i0n2x37mg5vpipknd72h57k6qqqmd";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ml-4.3.3.tar.bz2";
    sha256 = "04rpijjnbaj5267adcf7l85i1m5rdn10712vhmdfscsy7mikdlwv";
  };

  mr = deriv {
    lang = "mr";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-mr-4.3.3.tar.bz2";
    sha256 = "0mdp2rls0zykdb9ldqqk1413f70amvbla5a06gqan47js8smmywb";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-nb-4.3.3.tar.bz2";
    sha256 = "00lqjp5sg0dqw2c9cxqrx4y3vk3v4k713xj7nc4qkm172yrsngqb";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-nds-4.3.3.tar.bz2";
    sha256 = "11mjzs49zy6w45z22jlcj3kg0xvzrqfqgcm2l037hqs04djlgcck";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-nl-4.3.3.tar.bz2";
    sha256 = "15rfawzmzmvamvi1jnlzn4whksv595nhjajlfav6ps7wfphiwa7i";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-nn-4.3.3.tar.bz2";
    sha256 = "0pfa6ssgyv0b9vaggsi8bx7p0y1c8a99mdy5ngpd22qc3j885vnf";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-pa-4.3.3.tar.bz2";
    sha256 = "08l6mbcmsck00g1p8mpjmsrx5yjnrccpx77r2vshi07bp5lj6d2l";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-pl-4.3.3.tar.bz2";
    sha256 = "05nfkc4zg9nafms1v325vk05ndcgx27j8yxgds2radilzdqay6pb";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-pt-4.3.3.tar.bz2";
    sha256 = "1nv7k5091617xqnxzn6ssg6sqf822vygv707b02dragmp5l85s0y";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-pt_BR-4.3.3.tar.bz2";
    sha256 = "08y1482w8bjzwzad5b7igk4b9gsm1qnyqrg4pjjnii9886rgj37x";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ro-4.3.3.tar.bz2";
    sha256 = "12khmpq2w3zrpd45l10kr1k5vp73i722kqqf0zkvyc6plvjbcipg";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-ru-4.3.3.tar.bz2";
    sha256 = "0bjf0d4ss7kvvf0a6d6d5z9sdazfqbvrz6sx9w43dkx6gj4hnbzz";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-sk-4.3.3.tar.bz2";
    sha256 = "0r19i9dwlg46zl22ydz6yjp7rndmldv9cay91ch2fggkwd28m8mm";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-sl-4.3.3.tar.bz2";
    sha256 = "0y4rp69wpig9syim5w7xwbif70mqiibz4l3sdzspik4nvx87cn0q";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-sr-4.3.3.tar.bz2";
    sha256 = "1krw9dh719d3wa1zzlpynfpgpl41i1sr2q9gam2cmg56vn89p9pn";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-sv-4.3.3.tar.bz2";
    sha256 = "12kcf9nj98r3vpddgd5ywimxm316yf9f0n94jd9bvcnjz7zw8m0d";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-tg-4.3.3.tar.bz2";
    sha256 = "1i16l33x1hxdhrmacp5swcm2ha05xhb8aqbm7qpkxp489ffcvyr5";
  };

  th = deriv {
    lang = "th";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-th-4.3.3.tar.bz2";
    sha256 = "0y642apxgzhx74kshsdx4insfzw4na38xvskhrhs0i70wzvs1h6z";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-tr-4.3.3.tar.bz2";
    sha256 = "0canxvscyazqvm1wxr3wckj7kp03zcmly29liylp3i7s6f6pymws";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-uk-4.3.3.tar.bz2";
    sha256 = "1i9klbr74g85rpxlflcp3wz9y4y4aydbx9gjbj99flgx4fqq9x9w";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-wa-4.3.3.tar.bz2";
    sha256 = "1p9v4nsavh0rqhwy90zpx4anj3ifi02kqngq6s0ppzrgpck5d6qp";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-zh_CN-4.3.3.tar.bz2";
    sha256 = "1jq9qgsdazb1mid09xlm7gql4r8cwpd42cd733sfw942czhyvx42";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.3.3/src/kde-l10n/kde-l10n-zh_TW-4.3.3.tar.bz2";
    sha256 = "072x1lmdvxvs7vdn37zfgf78xpd1iv4imw6rywp9zhv15dpy9x4r";
  };

}
