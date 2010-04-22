# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.2";
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
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ar-4.4.2.tar.bz2";
    sha256 = "1vx0x08x2xqc0wcyjxnxfvb00vfgn99xzq8jx0408yj7mbm0a7h1";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-bg-4.4.2.tar.bz2";
    sha256 = "1jfwrl68b36220bffhqqgbj21cqgn7rw777skzn6gvzd6q19848f";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ca-4.4.2.tar.bz2";
    sha256 = "0mvls8fd9qzfj1qhv0lizm3vr22qxzpc0kkdcn77pc2ayrwx2psz";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-cs-4.4.2.tar.bz2";
    sha256 = "1x3yglhq3g159w0smrd9zg2blnk6xpc5bqdj6136rd9xh3xhg2m3";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-csb-4.4.2.tar.bz2";
    sha256 = "1jh3rqm95glz6xbl4fpydz13vhq6z3nys6hqbayvk3x4bygd2zy6";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-da-4.4.2.tar.bz2";
    sha256 = "15y8zp15sb8yqhbck3xkpw6h1aabslsddywcwk6d9y6ipw79vnal";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-de-4.4.2.tar.bz2";
    sha256 = "0xnxm7xlx777y0cx681155nzda68xbnmnf62gjvd6pxpcd40s3hk";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-el-4.4.2.tar.bz2";
    sha256 = "0jn3fwyy22s4nabzpl3pslp5z63yb50l29ca8rg4j7mz46xbsb3w";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-en_GB-4.4.2.tar.bz2";
    sha256 = "1vzlbax5m68xvgwp8ls4i8bj1lvh8bj88jh65wqqpf5w2rj3ndbk";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-eo-4.4.2.tar.bz2";
    sha256 = "0z3320czlwvsjij5rfv1drv6x4d61aqvxsq1yj876av4w7pys7r9";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-es-4.4.2.tar.bz2";
    sha256 = "0fsqcj809vf2zahkiqlmdxzpxzgwj437267lgfdjp65amsfw2cmd";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-et-4.4.2.tar.bz2";
    sha256 = "189y04kgbjx3pbbp46g1v9i5h9bz02zfgvy4l6nw1v97bnkrkjrr";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-eu-4.4.2.tar.bz2";
    sha256 = "0v41s33lvmyrlsn6cvqj42b8r0d36lci8lins3212g0sw5fkc83p";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-fi-4.4.2.tar.bz2";
    sha256 = "0j90qd3ll1ycj8d5ms4rmbkbw280cvgx47z5q6byfv4qaq2sq2bv";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-fr-4.4.2.tar.bz2";
    sha256 = "0sf0fdvmqrv6qxy6bmvb03fq9vdv1y4y28475s6vn6alz94q9ga1";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-fy-4.4.2.tar.bz2";
    sha256 = "1jb1mmw08bf9rmm8qipfwc86w9klcs1zynsyjfabc4p38jp4pirn";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ga-4.4.2.tar.bz2";
    sha256 = "0pijkmbj0bspwcrncn890ycgf2hxh2yxsayry0fkl9rcxz556bwy";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-gl-4.4.2.tar.bz2";
    sha256 = "02ccvdabnwp112483k2yb1w3b390cg61a7wl3pw02kkmxx5lcc7n";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-gu-4.4.2.tar.bz2";
    sha256 = "1dzpmwf7n29w3hfzhbyvj06jbs1mxxn46g9w98mclbis9ign10p1";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-he-4.4.2.tar.bz2";
    sha256 = "0my1l4nsjpyjgx118jdw5px0pmb621pyns5c4708y9if8pwdv7hv";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-hi-4.4.2.tar.bz2";
    sha256 = "0rj4bny1kv7rwnj01vcjxxa620vsdx5v03va4szhgdv4bm04j011";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-hr-4.4.2.tar.bz2";
    sha256 = "1l7vnjsklqk0dcb4zccifl77gaa9k72j70d0fa3vmw1bf0y7yld7";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-hu-4.4.2.tar.bz2";
    sha256 = "1zwxg38lspan3z3y3an4ypm7wwf1qgv1kz9k7p9jqj661j58g0j8";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-id-4.4.2.tar.bz2";
    sha256 = "0h59z03q9rv07g8hyzh2km0l0znddvflxz9jb047rgyll1ah96js";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-is-4.4.2.tar.bz2";
    sha256 = "15dz28jrzb38mn19l3wgprh9p2q1xsd08c25m911849fn4kvcs59";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-it-4.4.2.tar.bz2";
    sha256 = "1hqw8k6gns66clfaxyqdvbxmac1p2j2nl5vzabb9dxqxm6i4a6dm";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ja-4.4.2.tar.bz2";
    sha256 = "0awyr5iad03gjb2agcvyzpiq3hh3jdgar970n9g8d6in5p33jnba";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-kk-4.4.2.tar.bz2";
    sha256 = "173i7f236c55nsfn9m24s3pn63fkp51wylgj2whqi6pl3s2f2iz1";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-km-4.4.2.tar.bz2";
    sha256 = "0d9y8hvb2r55gj41g7gpr5iiz1dmayg05ry1yy1w1f800iv5756x";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-kn-4.4.2.tar.bz2";
    sha256 = "1s1ig0pa804mx59b7sxci3i5pa1gqb4naw123vay8g0mkq3jjnqn";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ko-4.4.2.tar.bz2";
    sha256 = "0x0gbpa0f21rm2ls2kjyjbz9wl1yj8bsc0qc3bl5g6xk4kr6j634";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-lt-4.4.2.tar.bz2";
    sha256 = "0jxdwqi7lz9brxw80kfix5wxx1x421n628zf4dkyd7szdl3svxc8";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-lv-4.4.2.tar.bz2";
    sha256 = "03yi2gj8ckdmz8wyq8dj1kwzl7g8xz5g3ppmw2h4w6xmh0kdbkdy";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-mai-4.4.2.tar.bz2";
    sha256 = "069mx66ib9bwjh0c0ndnsdrj2xlzdbbihz9yc4br1vd3disj1jd2";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-mk-4.4.2.tar.bz2";
    sha256 = "01k1bzmmq8g59xvyn4pxxapbd8x1a85ps2z241zlhlrpmi6faja8";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ml-4.4.2.tar.bz2";
    sha256 = "0vpj5i30p6hbabvqyfkzyjcwqblh2qz167bja3589halhdiadhf4";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-nb-4.4.2.tar.bz2";
    sha256 = "1kh0cwfds7gh5rda4vhccwrjlgmbvcgkwr9gyiy8ssx02absqcz0";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-nds-4.4.2.tar.bz2";
    sha256 = "18h7j89dmc95b24fgziixmfz1x8jhxnpwanhq3yb3f243j7rkvmn";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-nl-4.4.2.tar.bz2";
    sha256 = "0s2941ywppgpnvafqqbfciliv6qllsjm5migzbqd5pwhpjifjjsl";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-nn-4.4.2.tar.bz2";
    sha256 = "1phl56asdsn30wk2k9q6dhy99jvy2n11w2ny680jzdpc7gqp7j1n";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-pa-4.4.2.tar.bz2";
    sha256 = "0d5nksy2wr0glq5n82knfl4hhc6na55y5dp20q678agvxyz7nq94";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-pl-4.4.2.tar.bz2";
    sha256 = "1jbxbrqcp2cn6wijsm8jpqj925b5dc3s7120jqp4w25lr92gnip1";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-pt-4.4.2.tar.bz2";
    sha256 = "1c17axsrjxjq101wd0yihf098q3lhwxqii2i4wcjpvi3iarrc5ri";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-pt_BR-4.4.2.tar.bz2";
    sha256 = "0hkrj5kps37xifzsj89d9ky0hq7ddk9jblaccg22bwc4vh3d5vh1";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ro-4.4.2.tar.bz2";
    sha256 = "04qpzdic051xib0xnlg0jw9lnp45wgqc85l91a4pl50w3afcjcx2";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-ru-4.4.2.tar.bz2";
    sha256 = "0pbmr5pddys3rmsfy4zmynhzb3lc9381k2kw4nw3sqgv888p3xwv";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-si-4.4.2.tar.bz2";
    sha256 = "1kw60d4v71vrfpb9fcsvjk0inaws1p2wsd3cw3sr2xnqk9yiwx1l";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-sk-4.4.2.tar.bz2";
    sha256 = "1h3nkgvzifkk456kdnj0fmi4aazn08lz1s4km8699gl15zv6i5zx";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-sl-4.4.2.tar.bz2";
    sha256 = "0671a6crik2wn40kbvfa7dvwxdyznmac3frpvr2g20430g6d58n3";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-sr-4.4.2.tar.bz2";
    sha256 = "12pbjyij5dp9y6kxw995zw07fa174yaidc9mxsx0kv34sylnz9yn";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-sv-4.4.2.tar.bz2";
    sha256 = "1hs8szh09av5900s3cfjrmx8ynyz3ggv7l6gaaxsy4vfvslvd8vc";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-tg-4.4.2.tar.bz2";
    sha256 = "0mjlq6sbknd8lan9vaj8479a0hd6gk272d5an5n6d3m4q68smsx5";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-tr-4.4.2.tar.bz2";
    sha256 = "1g7lr6by3i32x0la20r1dsjbf6z376bd065rnfwdhnibaaidqm2p";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-uk-4.4.2.tar.bz2";
    sha256 = "13px5in34hkzwx25525cjbqlnxghqws1rnipm0mhb9q4yww98ccx";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-wa-4.4.2.tar.bz2";
    sha256 = "0g3jy5d5zxp8996i3n3g6fzlnsgkjf828x2xjz9494nx176xqdkk";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-zh_CN-4.4.2.tar.bz2";
    sha256 = "1yg2wg7pyknrc12fv9h78xh4imcqlzy5xxg266npv4c3n6b90xdh";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.2/src/kde-l10n/kde-l10n-zh_TW-4.4.2.tar.bz2";
    sha256 = "17q3ymwvrpp81rjw7vz60l3z6yg9mja0h5v37chzlbfnfdhngq39";
  };

}
