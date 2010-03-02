# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.1";
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
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ar-4.4.1.tar.bz2";
    sha256 = "09cs248qv8k6wnyd79jpikrx6w5mgl6n2q45g8ddhdjyk63x7ajf";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-bg-4.4.1.tar.bz2";
    sha256 = "137ilb8ij1mxrnm0snxarx0z4yw62z4c3x9ln9ic9zf5577l6m9x";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ca-4.4.1.tar.bz2";
    sha256 = "1687krcj082yxnjmp7ifd3579x8x07gkfv2vsr5052gibmhb6x6g";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-cs-4.4.1.tar.bz2";
    sha256 = "0l53azcvpl29crff61x0vaar8xwlf1jx5gc8z18kgbw0gvm6m1xf";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-csb-4.4.1.tar.bz2";
    sha256 = "0v0hbfs8ymafndwd2l8b2b18q2ar00hhyf0vh7p1kwvnvy0f6wxb";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-da-4.4.1.tar.bz2";
    sha256 = "1m09bi6jr9n1aww2lfkidk661ih7gdfq7d0hpzb70m28rig9xwfz";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-de-4.4.1.tar.bz2";
    sha256 = "0mvmh75vl3x711af5x25h4jympg4ifh4ai7fy0gv5i5c9gjdvxy5";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-el-4.4.1.tar.bz2";
    sha256 = "1mgh42phv34ryf24nqrbhbpmn6gnw2pq7dwiz7vybf44ai6x5ycw";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-en_GB-4.4.1.tar.bz2";
    sha256 = "0m6a867gwbl08xrpdv8gxq91n3czav6mp868gxvdgib75nfqk0rh";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-eo-4.4.1.tar.bz2";
    sha256 = "1brhq8hb65v34p3mzgryrp41qr2bahfrlf0hsjbz84cx8arm86v3";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-es-4.4.1.tar.bz2";
    sha256 = "0ssawrjwbg3fyhgp1d1fafb2yvhhn9zwfwc5lz2fnl9a048y1hlp";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-et-4.4.1.tar.bz2";
    sha256 = "0v12cqs67xkbcxf00nyailpn5yzhkslpdicyhgdch984zra3qss8";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-eu-4.4.1.tar.bz2";
    sha256 = "10adk7qz0jrmv420y4r2xwj9qydfhnciaprpg34afbc2vm4c0gwh";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-fi-4.4.1.tar.bz2";
    sha256 = "142irya0v3dm16iw5r6sh0aw8z80dyiybc9cizbnii4xdmwsx62k";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-fr-4.4.1.tar.bz2";
    sha256 = "0vsia4qf4x7l770ah5g9m5wcgjrhhqm5viy003qvnbn0a70420il";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-fy-4.4.1.tar.bz2";
    sha256 = "1d4gwppxsdmvb6hax04nns14jhhkjcylm8cw3km4hmhw2058xzwk";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ga-4.4.1.tar.bz2";
    sha256 = "1i0xmbsqf72zig64kis1bnw2qlz70006l9989bcifis9y99b6xi7";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-gl-4.4.1.tar.bz2";
    sha256 = "181yxv7nc1h3yz9kqfqdz2ykgjblp88ipgcwxvwb2486zmy5z11f";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-gu-4.4.1.tar.bz2";
    sha256 = "16ba0bn3yzp0v8nlyxhk6sg9v8khlwnf8b2griz9ffn18ayjfxdz";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-he-4.4.1.tar.bz2";
    sha256 = "1sdgw9bgxgkh05yxqvpplanzwmavjnyskzi6i6fw5yj9kfpbj5i4";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-hi-4.4.1.tar.bz2";
    sha256 = "1a909kgv343v6467p4jzqh4xi584zsn4b2v88ygw5nv2gb6kg37m";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-hr-4.4.1.tar.bz2";
    sha256 = "0ap1c2rx88i8dxz6109lb4lb3168hahg70n3rnjd8vwp1k337n12";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-hu-4.4.1.tar.bz2";
    sha256 = "1qa4mdfqya8fw9c2v9xcpbb7f6sjq0h9wrbpcl5rnks86d8ii2xg";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-id-4.4.1.tar.bz2";
    sha256 = "19j42p9vw6fgim4d4f3xvvmkrmybvz7a1bggqx6n2wi9ap8ibjwx";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-is-4.4.1.tar.bz2";
    sha256 = "1c8872gzri298qsr3grxgirijm6fskkxkc98a8wh5zcl7lplm5li";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-it-4.4.1.tar.bz2";
    sha256 = "1jsblj27lhrfiy9fgsnx8af0p7ginwhr7apmdkxlrcv6py0xn683";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ja-4.4.1.tar.bz2";
    sha256 = "0ifqvchb9k36m15z583vqlw61fa2rbw9ryqasjpqnqq1vs6dnir8";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-kk-4.4.1.tar.bz2";
    sha256 = "1zw3xwc37ibis9w4abxc9q4dqy1k5c3i4281v9653zkq9pgm66ym";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-km-4.4.1.tar.bz2";
    sha256 = "0nbn60pm2cvkbjqibdilzzfasc3i3bl8m77x1l6wqp7s0g70sq1l";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-kn-4.4.1.tar.bz2";
    sha256 = "03lg31qqfax0z2akm4hw8whlabbx0br8gyw8zpmk345nvk261rmc";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ko-4.4.1.tar.bz2";
    sha256 = "19mqlc1sgphar8pslkxzcrsz3h8z4dbyvl514bfwmpfn6q0m839k";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-lt-4.4.1.tar.bz2";
    sha256 = "112rhksnlr182vahrvcj64wzjzf7dmrywavr8agd0db2lalyrwpx";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-lv-4.4.1.tar.bz2";
    sha256 = "1q8jhmmycpk4lvk6n5q71v97adi2liaa97hy632ykrp6h1la7akm";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-mai-4.4.1.tar.bz2";
    sha256 = "1jczhqj5klw9lhf0ag9gpqzdj85zn9f180rypgs5nzphvvghisqc";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-mk-4.4.1.tar.bz2";
    sha256 = "1icdbgmcg1xakq9lxq1k8xr3i3dhirmk5428gzrxz7fgc63d5zsh";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ml-4.4.1.tar.bz2";
    sha256 = "074nqzaysmq0h65airwhcnk7n0dbm2fhssg72yc6bdi60yklhyy8";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-nb-4.4.1.tar.bz2";
    sha256 = "0r1hgm28dmllyk86x73srnq1sr4xa6f0wnmw9v8pgd5r1656pzzb";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-nds-4.4.1.tar.bz2";
    sha256 = "1bi41a28dqff9k2jf17v9djg8iq570j3ahxddv02fgp8lwsy8prg";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-nl-4.4.1.tar.bz2";
    sha256 = "11avyryx8xa0l2f5zn3jj0rk6n8kw5j1cjkhrq70kxylzpzaic1g";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-nn-4.4.1.tar.bz2";
    sha256 = "1jyz3cj1fxk0jbrakm97h1sd7qwmll4vab754vj3k8m8s2zlsdw6";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-pa-4.4.1.tar.bz2";
    sha256 = "0l8lk34xg6a686hrs4z8xrzhcgc1kr2x66vsr3lhwjid5krgc1g4";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-pl-4.4.1.tar.bz2";
    sha256 = "1yrb0cqw7bkw1axc0lx75lhxmx7mngg0nc07r3qx3sdg99jvihk1";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-pt-4.4.1.tar.bz2";
    sha256 = "18m3d6m8ikzifigqhrgczfv716dd3sshnf3m7gryl404xnm2qrrx";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-pt_BR-4.4.1.tar.bz2";
    sha256 = "0yvvzch1wgfnshk1b1pvak0jsssfbydqbdpdlb103l6jxkp3i7ah";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ro-4.4.1.tar.bz2";
    sha256 = "1j8x55bmp5rpssv3sqlj9i99zznpns3x712n34hhv8ykd7bwlqbs";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-ru-4.4.1.tar.bz2";
    sha256 = "0yfyavrljj9mxjpyyiqcmjbkyaqm2dv675b998m728bhsmy5i4kp";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-si-4.4.1.tar.bz2";
    sha256 = "0gm2p9fp0v6a5q4sj1ygww68pxqs3dmzdgc7r19ig9d0y1fh62xw";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-sk-4.4.1.tar.bz2";
    sha256 = "0cwygbnfmvcjcxr3hna4ymqb62disnkamqqf81xa04nizb640rnp";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-sl-4.4.1.tar.bz2";
    sha256 = "16zraz3143qfp6rdy2dh1iwkm2qaki0mgdhx11hh399rqrijpxba";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-sr-4.4.1.tar.bz2";
    sha256 = "02ywl78spi3lys7lndlxh3dma972lphvx4373qsbl9hjsggfv9i2";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-sv-4.4.1.tar.bz2";
    sha256 = "1ynn6h2nssg9iwkamkfgykv5520aj68vy3rlfrhgzbssh1760zzz";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-tg-4.4.1.tar.bz2";
    sha256 = "1g1rxk1h8aq4yn0v5g1vlljq9cwxyg5p0dr5432jlsglp4syyyx0";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-tr-4.4.1.tar.bz2";
    sha256 = "13l5qd83r4nqqib791y9p5k807kwrz709rbvnimlpikzibg9n743";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-uk-4.4.1.tar.bz2";
    sha256 = "1ipz2y6488gs2i0xkq0688ac0jnw17dxwj4rw81bas0khsslwq0m";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-wa-4.4.1.tar.bz2";
    sha256 = "17l4vda9ikxb3fx8f8ask6g9m0bqihq7q8h7c3fix5f3fjs94l6r";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-zh_CN-4.4.1.tar.bz2";
    sha256 = "103519yi7hi37rfghlbnxqz9fxh3jnrw4iq882w65zganq9gqck9";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.1/src/kde-l10n/kde-l10n-zh_TW-4.4.1.tar.bz2";
    sha256 = "02b25lxmjh35ymc11gcci1inhjllfz05yfbbaw1my18vfy6k1jdb";
  };

}
