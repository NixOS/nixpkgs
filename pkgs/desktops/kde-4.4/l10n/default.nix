# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.4";
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
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ar-4.4.4.tar.bz2";
    sha256 = "0x5ravkd2pba64vc0ss0r98plmxan07pkvqv1nc0h3bkrkv6bcm0";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-bg-4.4.4.tar.bz2";
    sha256 = "1xvx4c3v3pifpqq3qd3xkrhrc9xnkg5hhczd30akrphq8551z2sc";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ca-4.4.4.tar.bz2";
    sha256 = "0klixkxm1kgynpnzp8glxpj236x5n9p0nbd8ml3xzbk2pfamyay4";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-cs-4.4.4.tar.bz2";
    sha256 = "0lzsddqwr3wr0fa33rfcqim3p708c5hbwlazzs1xckwgl4ww97ri";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-csb-4.4.4.tar.bz2";
    sha256 = "0qr1l01xvjgvg1qjm8j01vpaiz61md9d78qmz3384f72q9iz6jbk";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-da-4.4.4.tar.bz2";
    sha256 = "0rvsap9y23mi16mfjq46dhw0628mia8k7criywdhkxhhv4dkmm1w";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-de-4.4.4.tar.bz2";
    sha256 = "0n9mlkvpl0xyyaxc4sjcrkj9x6n08qiljv01xh8mwwzd2v7pyprh";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-el-4.4.4.tar.bz2";
    sha256 = "08w17ym9gfbfxavhnd4l2cvlkz0n93d842a5q2nddgd5fx74572w";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-en_GB-4.4.4.tar.bz2";
    sha256 = "042mcshf5829vc6ix4rng0vkfl0y36yq4zyamnrawzp6b23y5i5m";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-eo-4.4.4.tar.bz2";
    sha256 = "0dsl6aqawyyv4fhr88cj9gmmccppyrwch4vggdnsj9hm7mq8lvcb";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-es-4.4.4.tar.bz2";
    sha256 = "0yd0cabrbbhmj8p0w9x38aii1w9xhxx08bp2vi0hdk9fw83pa298";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-et-4.4.4.tar.bz2";
    sha256 = "175731akqds7z2mx9lscy56da2pbwqj4abk6i41l5hs3dfwlcgs8";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-eu-4.4.4.tar.bz2";
    sha256 = "1783nw4hyxzs3sn1dgnqj7krp35ffzfqnw9jyn5hxrz0filzw4cm";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-fi-4.4.4.tar.bz2";
    sha256 = "066hc5p8vka8kl7ascb9vwvxjspxnysjhj4v3brs070prakv63d8";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-fr-4.4.4.tar.bz2";
    sha256 = "1b9w0hicgg3rxfgwf11rajcjml5h181llks8p7blasmbcsvccrri";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-fy-4.4.4.tar.bz2";
    sha256 = "1iwnmpv2dpvmmp5a8iwc07ag8ry3sjdmcx2w87la3drwmbx319gq";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ga-4.4.4.tar.bz2";
    sha256 = "1lvnimdndh9zqq69a6s8pyszrw5x08p4qikrq7mhgjh4v44crk3q";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-gl-4.4.4.tar.bz2";
    sha256 = "1n7y15fgi940r07vm26h30ijhq50w6l8a12a3mbsc1fyz8lnkf1k";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-gu-4.4.4.tar.bz2";
    sha256 = "1594rdmk2b59zah8s8v7g1d5r761cqk7ynxs7mi7lf644xy03b2p";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-he-4.4.4.tar.bz2";
    sha256 = "091c56g2h2hbxhpd0l9xsbbs2pdmsy4a8bisii7vm943q158pc23";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-hi-4.4.4.tar.bz2";
    sha256 = "17095ija6vnx70cpahpw2ynpp2jb4jrr4dfpx7yp68lnqwyaqa8b";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-hr-4.4.4.tar.bz2";
    sha256 = "1bpzsm10shippwj0w01y6jjf38bl97kmbbj06h6dzd7p4dk0km5b";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-hu-4.4.4.tar.bz2";
    sha256 = "1032m9a5g4y9x7lfhbnm1zl63m10vcikykza2ix5ks2q8ca9123h";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-id-4.4.4.tar.bz2";
    sha256 = "1rrqzgz58hshf7s01xp335bxpc28vsgkd18wcl0v69hf4gh36fa3";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-is-4.4.4.tar.bz2";
    sha256 = "01lkvaffpxv8ba8z6csxqb1kqxqj5r1idxw4qxbqw7dj8cjqj3d2";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-it-4.4.4.tar.bz2";
    sha256 = "0bfjk9lhwls9gyiy0ify3hr5jqjy5wcnlbh44mzf78c3y8snngga";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ja-4.4.4.tar.bz2";
    sha256 = "06j5ksv1660hd7bp9q942igi6wm47a4w6grx2q6lbvxc41ms5wk4";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-kk-4.4.4.tar.bz2";
    sha256 = "0vm5l5xrs1x9jy9zkjf43xfnxi2wc366j9y797pp04mh5rgdd2vv";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-km-4.4.4.tar.bz2";
    sha256 = "0ihzc62wkhindzl2fawcmvk87wbnbdm4f09pr092n6w2l8k8wz9b";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-kn-4.4.4.tar.bz2";
    sha256 = "15xxpb6c6g1v9girss9aimcbszdbq4ccsbq396hfn46kzxybzhjh";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ko-4.4.4.tar.bz2";
    sha256 = "0fzgyqajhjmlr9ibbd4jri00ccjji7m9bg02dw739w4rkvn5k6j1";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-lt-4.4.4.tar.bz2";
    sha256 = "126nnk3c1rkfhpy1nbsxkhad6bazbv6x9bh6kpqd9clwh8k35ya4";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-lv-4.4.4.tar.bz2";
    sha256 = "1n4szkfmyrzh6x3a85byzpn53lp8d4m0abp8k5kn2iksxh9z5mkl";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-mai-4.4.4.tar.bz2";
    sha256 = "0r65y0vxjbl9ghl7mg4dg58w0rbrlbhrllc6cyvv32xwjbi0qc3c";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-mk-4.4.4.tar.bz2";
    sha256 = "05whf03nlklz63qkgzmg6f7phj128q0lxyqbwvdnrv20v5pbld65";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ml-4.4.4.tar.bz2";
    sha256 = "1c572ygyhdnb3dl464v9zg6nb3l533qpkv4a54v7afswy6n61cil";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-nb-4.4.4.tar.bz2";
    sha256 = "0zl9m90arm5dn1nmapm5ignrx4pm46vyiid0p100id59yjwpk3a9";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-nds-4.4.4.tar.bz2";
    sha256 = "1cx54i2xl3zwlkq83xs1q0siap0hddqd4c4s0nqwgwp78vg9x0mw";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-nl-4.4.4.tar.bz2";
    sha256 = "0ydkr8ywkkndaik1l6v860zq6mfgdw8l8n0rgjkhs6ikvyd4gk5d";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-nn-4.4.4.tar.bz2";
    sha256 = "0vb5fgjkn0jcwsb173gwrr5kr5ihi885g09fb7j92dbpdp1fk4gc";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-pa-4.4.4.tar.bz2";
    sha256 = "0jn94b9f3bb7gv5anprcghmhn1wj6vzv8biflqzqk7bx6q07k70d";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-pl-4.4.4.tar.bz2";
    sha256 = "0p4hd5g2wkqahg79l9n2x7xy647kbf14jz00p8wpbxnbd2hvp333";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-pt-4.4.4.tar.bz2";
    sha256 = "0b0hk7sps0967dn4ryj43ihmbg3glspxd88f77z8ydccxi9zma2k";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-pt_BR-4.4.4.tar.bz2";
    sha256 = "1b9iy2mcm3l825kclrbs7sdsvgg5phi37aby3az8f25vh6mk80w9";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ro-4.4.4.tar.bz2";
    sha256 = "0da5awwls7h3pngq66gab420wlvmjj20pa5zhlmk2y1xdv917ysd";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-ru-4.4.4.tar.bz2";
    sha256 = "0dxs3dzg80vw5gqs8gfj9hkrvh10qm55gjzxj12ks1nwlq5j39wp";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-si-4.4.4.tar.bz2";
    sha256 = "14qppy24c4h7d96b0pc3m1jahkzpd1gxidrpi3cnvniw3qidr88n";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-sk-4.4.4.tar.bz2";
    sha256 = "1vf5dz45nqzg3cdwny9v59nwx0ja25bvwcrhrlqm7q4xl7g8iz8p";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-sl-4.4.4.tar.bz2";
    sha256 = "0nvp20hwdpci4gfdgag6j32dvm7a9j21x3kcvs4saals7gfqy1bh";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-sr-4.4.4.tar.bz2";
    sha256 = "0mw9b6bvgp6mfgzcjx9ircqajna7zf1k2wrp61l0v2cipj4apj5b";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-sv-4.4.4.tar.bz2";
    sha256 = "1sp500d8r7zxql4k0jbavxng6vhwcplvkzfwcvrgvq9326mn5x29";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-tg-4.4.4.tar.bz2";
    sha256 = "0abfl8y4m2y8nk46445376g55xsb51rzjg4jsqzzz6xqmxnhkz79";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-tr-4.4.4.tar.bz2";
    sha256 = "00kgm1a9q5jx6cq3flvrnasj1lwgcqf2kac6wa7qlqpy4nqw2vfm";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-uk-4.4.4.tar.bz2";
    sha256 = "0l1r2xphq8rlnjf0hqdplsk47a35p6sxvdp9g9vg26gfhd7156zq";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-wa-4.4.4.tar.bz2";
    sha256 = "17yijs2mk7sr87lms7wajvxxrf888gbz75z9fza6kp6mlvbjc1a0";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-zh_CN-4.4.4.tar.bz2";
    sha256 = "1qjr3jlr539lm2mkgn2bma98zdy91frih2bfzl1jxrdp0swnkzh5";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.4/src/kde-l10n/kde-l10n-zh_TW-4.4.4.tar.bz2";
    sha256 = "1s6dg6imqjb4wxljd1jblwp6kqkzcnybhndfbzhsb691ivi42mh5";
  };

}
