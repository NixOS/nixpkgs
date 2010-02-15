# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.3.5";
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
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ar-4.3.5.tar.bz2";
    sha256 = "11781zszchvrp7ac6hhyhhf9n4c87n8x9m4cfc0ndg9scazm7dkg";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-bg-4.3.5.tar.bz2";
    sha256 = "139if584x2cpzxwrav2cgjbknclcfk2k67jy8caxikzkjqi6z17q";
  };

  bn_IN = deriv {
    lang = "bn_IN";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-bn_IN-4.3.5.tar.bz2";
    sha256 = "0sygvwsc5b7dscpvy21zvvzshk48x81qvkpxrdl02wsd9xzfkk97";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ca-4.3.5.tar.bz2";
    sha256 = "05bqqjnlm5xb7rcr4lry8na1znsjcm4gjjdphhlz87g3172h81sr";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-cs-4.3.5.tar.bz2";
    sha256 = "13c2vqlfd65ryk1z2x2lx5m56is2sqxmasc2m8kpwxp1sb5cip0n";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-csb-4.3.5.tar.bz2";
    sha256 = "1pg15wpiinbizia50cfmhaqyap52jcb1v3ymcz93dzin32s4ksvz";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-da-4.3.5.tar.bz2";
    sha256 = "0inmvn425ykc3a0vq7gcf5igav3c3b9zhchmn440y124alm87zvl";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-de-4.3.5.tar.bz2";
    sha256 = "01cmklxih5di3k1ga2qa690ff4zb1m4j1gnazcqg50c6z9rw8g2y";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-el-4.3.5.tar.bz2";
    sha256 = "0qf3psm57w21sqnb8s8n599d9hp83fzqqwjdgq9xyd7jjsy2amlh";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-en_GB-4.3.5.tar.bz2";
    sha256 = "0lkr64rk4sxszcz998k3xpnaz8hjz0l05gmm2pqrfl5ryi6l88nm";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-es-4.3.5.tar.bz2";
    sha256 = "1aayj0zvw7if8x3qjzg4piyar70pbx5szq38i4h0vqqx4q2cv8ik";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-et-4.3.5.tar.bz2";
    sha256 = "1ww4cgwmzbr23n5ilqjz92a0b3qa20fmyfll36pnphjrp0vmr4vr";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-eu-4.3.5.tar.bz2";
    sha256 = "1ckydcs3aw36vfi4ik1qk6kkadl3gm8j7gf8z8wc86sn4hbpb75r";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-fi-4.3.5.tar.bz2";
    sha256 = "13lv39vq65n5d2rlfy98512slwl3n0lh43j1la9r5gb7930z8w9j";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-fr-4.3.5.tar.bz2";
    sha256 = "1a4rgwisfc7d6g7qvfd19jzkfhlaacf6shvm97af4hmdpb53jd9n";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-fy-4.3.5.tar.bz2";
    sha256 = "03hd3m5fn4dp3qnqa6mfp1n6rs4irap3p7by0zg118m06cqpy30v";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ga-4.3.5.tar.bz2";
    sha256 = "0hn0q0mc3yyhhl6xhmx8fqrbr1m79z2lv00k1mp11zjd1hpb0z1v";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-gl-4.3.5.tar.bz2";
    sha256 = "1xv1zwzrbzc95g6l214yrhpp0ldxi1n2vq89gbp8zl0qf27d7jgd";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-gu-4.3.5.tar.bz2";
    sha256 = "16rhzn9gdxnc3vr3l7j16pm249mh35041kfz607klzvifjr6ncpv";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-he-4.3.5.tar.bz2";
    sha256 = "15xmc6i43f1jqmrslg067s28z10618ikfcfbyxxfp4bw02g2mgv8";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-hi-4.3.5.tar.bz2";
    sha256 = "1l17rsqilf4r495bfhcxpbz03sxi74h0f5b3xhdl499qxg9c2frc";
  };

  hne = deriv {
    lang = "hne";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-hne-4.3.5.tar.bz2";
    sha256 = "0x9qdlgz6p6rqa8r1zgk6hxpq2v4sab4p6bm799qanq0jz50lbqw";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-hr-4.3.5.tar.bz2";
    sha256 = "1raxh7w1vg6ic7ic61vl0px3c1jinyygzn1zhm29qn4k9in5b4sm";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-hu-4.3.5.tar.bz2";
    sha256 = "08iladzh7ls8nyn1283a0g7phgq1yh0ng78apvhzvjhplpa0y2dk";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-is-4.3.5.tar.bz2";
    sha256 = "0rnni9il5szllfks25jf8xplpv4i2qbqwppi0fimiwg71a1kabh5";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-it-4.3.5.tar.bz2";
    sha256 = "0wpmx4sn9civkc05p6qc4g7yj6ypamipn206lzgdp2vdf2kfaqzc";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ja-4.3.5.tar.bz2";
    sha256 = "07vm8lnkif9hry13fi2dqa7hnw384bajyn0p0p4p0yfb8ahf4983";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-kk-4.3.5.tar.bz2";
    sha256 = "1bp9zyw6scwc0cmc6zncsj2mvh85llw0ynw2sa5cykhrmjyzmj58";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-km-4.3.5.tar.bz2";
    sha256 = "1azymrqyiyab9w9v9x5csklcawssxqyx1i8ynndh3a9pkh5k7hca";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-kn-4.3.5.tar.bz2";
    sha256 = "1yhgp7as9s75565b4b954k20slgrcsydwfjlx1cvlrk11hjj3d1w";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ko-4.3.5.tar.bz2";
    sha256 = "09w9v28wxwlg452rff2zglqm8pr2idd2c7p3l20jdi8539skz0cj";
  };

  ku = deriv {
    lang = "ku";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ku-4.3.5.tar.bz2";
    sha256 = "0hgi8kabb4z581m10qmc2nj99m1mij9ah4sjmrc605fr65cmj70i";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-lt-4.3.5.tar.bz2";
    sha256 = "0mdw5lz0z6qg2wigmxz0kb7png80zbnnwnal101xxa3x1bdyvn2y";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-lv-4.3.5.tar.bz2";
    sha256 = "1kf7hw35j0j9fwld6xp7gs9849qxw2wsszshj6q6a7w4fnwkb6ka";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-mai-4.3.5.tar.bz2";
    sha256 = "1dy9vryip9qrjdwgk9cqan1xjxw46nz61jnsv982i4x5x7rbv8h4";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-mk-4.3.5.tar.bz2";
    sha256 = "1j2mmag8xvm1h37sdvr4n6zsgrhlkx5z6zzca8gb0i14xy79653v";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ml-4.3.5.tar.bz2";
    sha256 = "02lcbm1rnv1cwwipx1hacwpc3yd7xi5liy7ibdrfk8b11iqvqizy";
  };

  mr = deriv {
    lang = "mr";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-mr-4.3.5.tar.bz2";
    sha256 = "0dh5a16f4rcdz9jl3zs6qn27x3r7b0xicyl8kh95a2qix8s3x7cg";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-nb-4.3.5.tar.bz2";
    sha256 = "1g7xpk34lhbsr4qc008dhafs5w9w2wimwf815pwnzpc4phdd6dkf";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-nds-4.3.5.tar.bz2";
    sha256 = "0dc7q482jlcxzwkrkkjp1np2mqrhzs0pmambwqcqrpriqk4l6c1i";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-nl-4.3.5.tar.bz2";
    sha256 = "0l086ivwanliw841v1wdg3xi68c4dss1bdhg9zi6wy6girv3mld8";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-nn-4.3.5.tar.bz2";
    sha256 = "191kvzya9c4yjd4kkrn23skqg1g695n8r4lwvlkzy7lwxl5pg8cf";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-pa-4.3.5.tar.bz2";
    sha256 = "02by85vkj8w60q5azqbcif00lcmfa9rg8kkzhh25nh6iqmv7z8g1";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-pl-4.3.5.tar.bz2";
    sha256 = "13cj00da6l52zblvvfcv6cxb43qchf20pfmh524fpqy98r2px5lf";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-pt-4.3.5.tar.bz2";
    sha256 = "067pgn8w5hr6y049mh9481lwy26ljr11nnpnj6qfyfrh4cqf42ms";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-pt_BR-4.3.5.tar.bz2";
    sha256 = "00wv1lzcfqphcn5x57wgd0afzn708mhf3rvwy68rkvnh24vr0731";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ro-4.3.5.tar.bz2";
    sha256 = "1x1lcnindcm50ady5v0wfl8xzjvjw146iavd4jf0iv301w7f44jb";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-ru-4.3.5.tar.bz2";
    sha256 = "0xa27l2wyy8n2ipippm1rcwpcrav08kq4dmjm1j1z9i9bi8d3ply";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-sk-4.3.5.tar.bz2";
    sha256 = "0cnf97bc9rx1nwbpmvrgfvfmkh0bm3r4bhyxwl2nqh7ik7h6x3gp";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-sl-4.3.5.tar.bz2";
    sha256 = "0snm1hsnnjxdw67qr97ng49jcnfjssdxm2dvfwz3k5ggv5dvrhmb";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-sr-4.3.5.tar.bz2";
    sha256 = "0kxg77vdb8nbs3wpczmkwr51gghvzqlc0zpnhg4xqd2h3nwppm41";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-sv-4.3.5.tar.bz2";
    sha256 = "1gb7xc7d7dm35znfxxkg42lb5g0i3vh3sz5mv69qdn24j6nzqrxg";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-tg-4.3.5.tar.bz2";
    sha256 = "17j9nbimyvgsa3j0bcy4kzlksl64m1wflwmymsl73a0lk0f1djyc";
  };

  th = deriv {
    lang = "th";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-th-4.3.5.tar.bz2";
    sha256 = "125w3s0zva8z48a5ni34qqhyppvka81rd840y6q70c9v0n3alw53";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-tr-4.3.5.tar.bz2";
    sha256 = "1f9prapy96yxvnl1gmvxbccy5ibjv0mn21a3mf9li7yvnjblpav3";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-uk-4.3.5.tar.bz2";
    sha256 = "0gyyb75d0vd841bkkr6n3w3a375qr74yfiz1ccsnsjdkbigpm5x7";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-wa-4.3.5.tar.bz2";
    sha256 = "0hq4nnhll53g7kmw2xzg0kj5zg4cg19gfbnxv94s9lkn5djkigaw";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-zh_CN-4.3.5.tar.bz2";
    sha256 = "0fgjm04pby0nal85cvjrzxan4nmiqzykfq39b2c3q2ispikra0jr";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.3.5/src/kde-l10n/kde-l10n-zh_TW-4.3.5.tar.bz2";
    sha256 = "10gphism03i7xk02afbf2ndr1h5c54slix2b3hvzj4klqxq0ai8p";
  };

}
