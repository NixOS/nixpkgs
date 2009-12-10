# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.3.4";
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
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ar-4.3.4.tar.bz2";
    sha256 = "0dgk97j0qv8qxfhiwv0cwqbmfgnxn0k7znm7vd40ngblbp4k75y1";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-bg-4.3.4.tar.bz2";
    sha256 = "13mshqlskqndfm20s07978300p5ik432krhdk9k5a049f7w543dp";
  };

  bn_IN = deriv {
    lang = "bn_IN";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-bn_IN-4.3.4.tar.bz2";
    sha256 = "0zh7zra2si0z966r8qq41m3g4l9864acfg70hjbgr4bhvhn642zd";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ca-4.3.4.tar.bz2";
    sha256 = "1ry403z9qgimcj8nilznr0f7bkviybcpwm3clww13na74ngmz4a1";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-cs-4.3.4.tar.bz2";
    sha256 = "1gd0rl0c59fawd7s20nrmnc5vr915aqhz7f57wrgpw2kxgva33nk";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-csb-4.3.4.tar.bz2";
    sha256 = "02b8341cpgzbp4ijnzs8bkvynz9mhz18ma5yk66i9q0js6rk8bn2";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-da-4.3.4.tar.bz2";
    sha256 = "1r7kn5qdcx64p0rlj9mb3011hk5rvrqzvr8k6nrfsfmw2h7mnjym";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-de-4.3.4.tar.bz2";
    sha256 = "0nclr4chx2ir036fjhs7zp2l1k43vn11lww7338v2nn9mcwfdyn3";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-el-4.3.4.tar.bz2";
    sha256 = "104ycjq95zhkv2by36lndqc2w2shn3dp386ir5wj52x4f26j1zd0";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-en_GB-4.3.4.tar.bz2";
    sha256 = "044s656x90xdgp14cddsz499bxfhsscnngvx4q13pnxrd2gbr2xj";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-es-4.3.4.tar.bz2";
    sha256 = "0fx40sx0cqjashlj9z9da2jndwbg6s36njsgsx6kjfd90p23snvi";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-et-4.3.4.tar.bz2";
    sha256 = "08s9y9h9qx2ahz1chmlcycldmf543c0kc8wfrsryrf1iaajdma0r";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-eu-4.3.4.tar.bz2";
    sha256 = "1q0vjvbc6lywpqzizi61cz91scrkjplxjp2jywyi6dnrv475w6b9";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-fi-4.3.4.tar.bz2";
    sha256 = "1z2jmcmr46f0a5hins4hkj843r3bd6azykiz6nwwkgk7png21axm";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-fr-4.3.4.tar.bz2";
    sha256 = "07fi4c7k9h69m5jacp0vlyd268gxljh2j3hj9fk5vka4333rp2x0";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-fy-4.3.4.tar.bz2";
    sha256 = "1l22bjccdxnsqgsns3nbh5wwplacbjgxhw72lvysnc3c7kkjm789";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ga-4.3.4.tar.bz2";
    sha256 = "1kkz7gsyfpzrvy7pg2gajw24jybr8crk5yighp9mqa337cqjma6z";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-gl-4.3.4.tar.bz2";
    sha256 = "161dh3w3jwrlzk83is3v25nvaxi5441n3q3bp6kg1fc1jqsinyr0";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-gu-4.3.4.tar.bz2";
    sha256 = "1i69ma0cw85rf0gxa1wzlbmdhqm3lzyk1br4m4m6iz68am61pkdr";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-he-4.3.4.tar.bz2";
    sha256 = "0353x14wmh9r1q46vcn2m9sp6fvrfzkj55v0kh0xbh4jdprw8cpn";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-hi-4.3.4.tar.bz2";
    sha256 = "1wing32i5f12qn3w6f4zlf7dwvarf8wwzxxvb1jjld16m7vxkksx";
  };

  hne = deriv {
    lang = "hne";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-hne-4.3.4.tar.bz2";
    sha256 = "149nahrhybv8cyxdqwdj7p787vsh902yr73r7a0l1sjblisrx84g";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-hr-4.3.4.tar.bz2";
    sha256 = "0wg2qahvz8lanv4kqp5128paja7sai68prbincfgfwbi4xdbkfnq";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-hu-4.3.4.tar.bz2";
    sha256 = "05vkqxrw3rxb2brm3ggb600al1ggrv739qdfc1m659m1qxhnxgjw";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-is-4.3.4.tar.bz2";
    sha256 = "0212ymk3h58bmhaccprn5wfs65fhcpaq73dnqp3v0xmgkfnz6dhy";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-it-4.3.4.tar.bz2";
    sha256 = "0h72ln0jwizxg86kwk6m1zi1wws14prv9xvlzhbmyvcb0sa98v75";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ja-4.3.4.tar.bz2";
    sha256 = "0nw4ybl429y3d9d58y13gyaxzrkrvjgxz4vn68ryn8vlb8d0sb6j";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-kk-4.3.4.tar.bz2";
    sha256 = "01j28srx3vbgs8l0vv30fx3ki05i18ddf6sg2jqdli4ylg517l66";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-km-4.3.4.tar.bz2";
    sha256 = "1zdbvgn1lz9lyzrkhjf05k7n1cpdjwzv1v62aja7h438qn8scqnh";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-kn-4.3.4.tar.bz2";
    sha256 = "193ibxndpgl400djlggwsy6h3mjdkhmvmc5dalh9h2k3fz9fdswn";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ko-4.3.4.tar.bz2";
    sha256 = "1888mwknd4l8rcs01w1mi7147cl9phylxjpcsmg3gda61pq12035";
  };

  ku = deriv {
    lang = "ku";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ku-4.3.4.tar.bz2";
    sha256 = "1w70dc75k6s8mpn1fraz1znknfz6cpdbb96frh611fz3r3hzgaix";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-lt-4.3.4.tar.bz2";
    sha256 = "098cw3hz9w0kb2b33p5qwxli4z38qw4rcby4j75hwm66l6fw9iqk";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-lv-4.3.4.tar.bz2";
    sha256 = "08rfi68mz8iarmscvnn11b1gyr7k2j0gyhs7673gnk5m3avmz2ab";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-mai-4.3.4.tar.bz2";
    sha256 = "0pkad1rchrra15jjij4r76xy26zkmshm80amqfn8ba9nabxr7nxa";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-mk-4.3.4.tar.bz2";
    sha256 = "041iw3754j5x6b02yzk6zyy0fggmx1lq1kgv1d3g5nxv2a4dp311";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ml-4.3.4.tar.bz2";
    sha256 = "0y6050gb5vrlpbimackzzpsv08j8zxp67cg2gdn4x0v31xpvpxfr";
  };

  mr = deriv {
    lang = "mr";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-mr-4.3.4.tar.bz2";
    sha256 = "08asxp8g0qijla04m29lb16544gdibk6d4vf92zmcsff04a1wis2";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-nb-4.3.4.tar.bz2";
    sha256 = "179p6ha1py6j9rinzknqqcr8p062x3g9jz2m160vklsc780y1whw";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-nds-4.3.4.tar.bz2";
    sha256 = "144rsvkw2qr4cd8zh0sxpvnc3rh17i23l3pxhpk65ldq6b7xnybb";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-nl-4.3.4.tar.bz2";
    sha256 = "15gnqpg7blc3aj2pdj5pswmimlyhic18jqrlgjk3xsxq4744r4wc";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-nn-4.3.4.tar.bz2";
    sha256 = "0414fmkm19n5bjvbdcxh9vkn0hmpk3w2r60lvm7gmpi8zdak0p2p";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-pa-4.3.4.tar.bz2";
    sha256 = "0974jsd3l70ygipzf0fv5zvs9ykyn4c6dnm9gf0krdzxskrimfxp";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-pl-4.3.4.tar.bz2";
    sha256 = "0f5hr7mff4a8hpwapz67wjlg02jwdnainaa8jk2j64lwzbswybyr";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-pt-4.3.4.tar.bz2";
    sha256 = "07bclil0lhr59faqr8a59bfmvsdjla0pg0x0a4qqmnqhhan1ki3p";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-pt_BR-4.3.4.tar.bz2";
    sha256 = "03y3fk1b2yzp6jbaic76y06522wbq3lzxf1pbc5xi22q3gw14dls";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ro-4.3.4.tar.bz2";
    sha256 = "0nqdl8jbr29bjdvxdppbmjjgamh68gcg38j8gsh5zp6ak1ac2abc";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-ru-4.3.4.tar.bz2";
    sha256 = "0n5g26p98dshngv35izfc826ahirqppx4ig6ycj9pfza5aakajah";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-sk-4.3.4.tar.bz2";
    sha256 = "0jwh0sx09hxz922snak4jxajcl1p3rciycwqw4fgmk6fx5ra7s48";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-sl-4.3.4.tar.bz2";
    sha256 = "063lbb2g5zpg3330hz749m5kh9hx8xrf7ifj95xjkbkh1sa0g2dm";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-sr-4.3.4.tar.bz2";
    sha256 = "121vdrzk9fm30s8q4m5b7vd3lv3n4azzx7dm62qx84qyx9zs8r4y";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-sv-4.3.4.tar.bz2";
    sha256 = "192yw9vjwv9s7bdmcndqq0dx0g6djpjbyiq9skpzpq21zphgf0n1";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-tg-4.3.4.tar.bz2";
    sha256 = "0q90k5fk6f41baiyxl3055y6b55nx7plq7hzlkp1h2d60q2d8yhs";
  };

  th = deriv {
    lang = "th";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-th-4.3.4.tar.bz2";
    sha256 = "00jc6dkhpcxc95jkg7v1fsgn2ymk38mqs0h8x1an23jgs5sbl43r";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-tr-4.3.4.tar.bz2";
    sha256 = "1igr4fw1h3617kyqhxdgg798k1gdiwxz5g2s59g281vm16r3rg01";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-uk-4.3.4.tar.bz2";
    sha256 = "0sir7ayb2ydrhl5dbq9ni10l2w45blh9pdd7bpfxmgqz7n1kylp8";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-wa-4.3.4.tar.bz2";
    sha256 = "0ip3idiq6sfxzgg872sjw9ra1sy137q9m47ik3fdfcxgfwv7bj1r";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-zh_CN-4.3.4.tar.bz2";
    sha256 = "0c8m6zj3pzr0pkmb6m3h6a5n274s2v8wpp7gfqkxrkardq0scwxb";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.3.4/src/kde-l10n/kde-l10n-zh_TW-4.3.4.tar.bz2";
    sha256 = "1xiav7nhvkfpizih845z1cr8avkphvszd4j8i547lcb8xnvvk0bw";
  };

}
