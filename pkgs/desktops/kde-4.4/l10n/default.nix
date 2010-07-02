# THIS IS A GENERATED FILE.  DO NOT EDIT!
{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

let

  deriv = attr : stdenv.mkDerivation {
    name = "kde-l10n-${attr.lang}-4.4.5";
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
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ar-4.4.5.tar.bz2";
    sha256 = "1nc5kpy4cq7cjck6dfzql9djmnimz0khngscdrl8yhahg78sndq7";
  };

  bg = deriv {
    lang = "bg";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-bg-4.4.5.tar.bz2";
    sha256 = "136llbcv3955ih33ih0j2ccbnj4whc9jidf9flr7kpkz5pin4k11";
  };

  ca = deriv {
    lang = "ca";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ca-4.4.5.tar.bz2";
    sha256 = "1qc9ka78qcmy0pq9q7xa61lmcfz77picxlzs0g46npv073kyn4xp";
  };

  cs = deriv {
    lang = "cs";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-cs-4.4.5.tar.bz2";
    sha256 = "0q9cay61sv6rrsim3v91n8xbpsc0qm97sbhgaa6p5s63xpvpjzp8";
  };

  csb = deriv {
    lang = "csb";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-csb-4.4.5.tar.bz2";
    sha256 = "1yy1jdjskz96nha1lmxy4yjl8wfljp4qgzydxw2pcac54hr6wgxr";
  };

  da = deriv {
    lang = "da";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-da-4.4.5.tar.bz2";
    sha256 = "0qdqa31i0vyg95dqbwg3zyprzdgq7xmvk3iax5dsi9q2bms1cxq5";
  };

  de = deriv {
    lang = "de";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-de-4.4.5.tar.bz2";
    sha256 = "0562srr33k648q8xc3865j9clrwqj8ihv7n6f7dmnbkcn93jcp5x";
  };

  el = deriv {
    lang = "el";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-el-4.4.5.tar.bz2";
    sha256 = "1rc7cap8xb28bv7f1fk3m1mbylixy246zq4srws0pawdfdm9k5nj";
  };

  en_GB = deriv {
    lang = "en_GB";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-en_GB-4.4.5.tar.bz2";
    sha256 = "0zpj06jx77fviv90k56br94fn28bimfhva3r12idr6fli5il99y5";
  };

  eo = deriv {
    lang = "eo";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-eo-4.4.5.tar.bz2";
    sha256 = "1mwmlg4dxk1alzq768j07ccyflil60dm63d6008s2hg4jw0pgpkr";
  };

  es = deriv {
    lang = "es";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-es-4.4.5.tar.bz2";
    sha256 = "0flddrdkys6p7cd5vfakdl2g7vpc6h277a4phszmlnssfr2jlhib";
  };

  et = deriv {
    lang = "et";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-et-4.4.5.tar.bz2";
    sha256 = "0vpn8ylr336i9hax24jvxxy284gaw7jcxwqxgkqc3c7fl9nji7xz";
  };

  eu = deriv {
    lang = "eu";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-eu-4.4.5.tar.bz2";
    sha256 = "0q0h2q73jha1vgk60b1ycfh2ci5vavscva9a1xl42rzkxrqzp7bw";
  };

  fi = deriv {
    lang = "fi";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-fi-4.4.5.tar.bz2";
    sha256 = "19anfv3jxlnzs6mx5qlfj9v6nxxpbn2g5vppj771y7ir2wgx79gx";
  };

  fr = deriv {
    lang = "fr";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-fr-4.4.5.tar.bz2";
    sha256 = "09qzm6zr8rjsr50bxr3cnsfj4l4qpzf1dmkx3qk0vvvmagry23vy";
  };

  fy = deriv {
    lang = "fy";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-fy-4.4.5.tar.bz2";
    sha256 = "01pa23gxy0a3jsnsdvsbgsfdfvwiancyx3w4fw3gx4b4j9y9gfry";
  };

  ga = deriv {
    lang = "ga";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ga-4.4.5.tar.bz2";
    sha256 = "0dfq497v8shzr2r1nqs093nyd32ka74wznp20z2wgsw8yfylgbhs";
  };

  gl = deriv {
    lang = "gl";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-gl-4.4.5.tar.bz2";
    sha256 = "0lp443wpi7gj7i078mxbxswk4niziqc5iyw4mx94cm4g0h2k3cba";
  };

  gu = deriv {
    lang = "gu";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-gu-4.4.5.tar.bz2";
    sha256 = "0s959r1c5klh0cr6mczmmfzsgvzyihpacia46q8ckvjddx7zmb0b";
  };

  he = deriv {
    lang = "he";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-he-4.4.5.tar.bz2";
    sha256 = "090s786g9f1jas8dqsh7hqx5idzckd0lg5gz1v7fx254qnfmj6rx";
  };

  hi = deriv {
    lang = "hi";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-hi-4.4.5.tar.bz2";
    sha256 = "1ysw8h7v0a2idf13jxi46k1b28vg8yl11hfzin4ihfbr5q03fqck";
  };

  hr = deriv {
    lang = "hr";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-hr-4.4.5.tar.bz2";
    sha256 = "0fh7mfzy41mx0c3mvrv2rdwmk82mrlb84azzvfsanznzk74pnbgr";
  };

  hu = deriv {
    lang = "hu";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-hu-4.4.5.tar.bz2";
    sha256 = "1yw91mzc4mcjzqk7syxkxybby6ay02z8ssbhbjm8vb52mh1a9js7";
  };

  id = deriv {
    lang = "id";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-id-4.4.5.tar.bz2";
    sha256 = "1ds4ncfb4xp0bd0dijichgp289abhm10f285bwnanzzjn442i4x6";
  };

  is = deriv {
    lang = "is";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-is-4.4.5.tar.bz2";
    sha256 = "07xx45wy1n5kqg6fwdl27w1kpvqs6djj6yv6lxq2vbh5di3h5zpj";
  };

  it = deriv {
    lang = "it";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-it-4.4.5.tar.bz2";
    sha256 = "1agl195pkxh55669gmcnd97z3bd9ff1c448d8rnq2rqr0xysj1mr";
  };

  ja = deriv {
    lang = "ja";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ja-4.4.5.tar.bz2";
    sha256 = "0axra17rpv5hdr83yvd0n3kgp51frkf5b5kfg1bg7sf44kn9fhv5";
  };

  kk = deriv {
    lang = "kk";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-kk-4.4.5.tar.bz2";
    sha256 = "1gkli53ryfbb64b9x2fl76cid98m99lxszn0cczfmfdvjlc0vgxr";
  };

  km = deriv {
    lang = "km";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-km-4.4.5.tar.bz2";
    sha256 = "0113z5560zsjr9jrgh58nch9h4xlqclld2zqc8yah90i7jpas3aq";
  };

  kn = deriv {
    lang = "kn";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-kn-4.4.5.tar.bz2";
    sha256 = "0m6gz9sl21hfnpk3z8y33aqfv17z1x1b8j24jf88qvl01nsk4889";
  };

  ko = deriv {
    lang = "ko";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ko-4.4.5.tar.bz2";
    sha256 = "0j30rj155fcd0wmbkbbwm2vybb9x3g6dq3mipmf1zipm1nm7m64l";
  };

  lt = deriv {
    lang = "lt";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-lt-4.4.5.tar.bz2";
    sha256 = "10swp16mab3kh393dcwn1k9qm5jrcqigixrw39hlbsyaw9jf9j37";
  };

  lv = deriv {
    lang = "lv";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-lv-4.4.5.tar.bz2";
    sha256 = "0niyc9awcdfnx3gi63vw83ni1nb870384f4wyhmms8zdkvca5hjc";
  };

  mai = deriv {
    lang = "mai";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-mai-4.4.5.tar.bz2";
    sha256 = "1clmcpqj4m7mwf2v62500jqjb94gpmlzxjp3cflraf9w4nmvv66a";
  };

  mk = deriv {
    lang = "mk";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-mk-4.4.5.tar.bz2";
    sha256 = "09gbk50bw7d8hpj0jwyz0wzd34fq7h9r35vj6750vpv7pbyz4l7q";
  };

  ml = deriv {
    lang = "ml";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ml-4.4.5.tar.bz2";
    sha256 = "1bsr4civp003wgnpl790z5cfh1rayn7xc6lvvrpk4hrcr2b5skj9";
  };

  nb = deriv {
    lang = "nb";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-nb-4.4.5.tar.bz2";
    sha256 = "1i9chazhp0s22rva0swkvd7zpl5my6pbgckn5fj924fkbs6336jl";
  };

  nds = deriv {
    lang = "nds";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-nds-4.4.5.tar.bz2";
    sha256 = "0kyn8mn8jm03sd56q6hm884ywshl5i6wy9vmskaqpclp9y6xbwlc";
  };

  nl = deriv {
    lang = "nl";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-nl-4.4.5.tar.bz2";
    sha256 = "0fnssviivx8xdg9vq5iy44al6dz82mg3p41ngkyghh25xfm0iswr";
  };

  nn = deriv {
    lang = "nn";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-nn-4.4.5.tar.bz2";
    sha256 = "0mfr3jqx1nrd3gf4319c29f3hhks9b2hn7r6bidwsmipar8b3pgd";
  };

  pa = deriv {
    lang = "pa";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-pa-4.4.5.tar.bz2";
    sha256 = "0aciihaprzndn5j4d8dsc2b13sq1xac89j6r0assbvhgmix06844";
  };

  pl = deriv {
    lang = "pl";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-pl-4.4.5.tar.bz2";
    sha256 = "1xq63d020k8fyqc0akpm3kvqrvg2g91r679ny51n13xmdcq59y1f";
  };

  pt = deriv {
    lang = "pt";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-pt-4.4.5.tar.bz2";
    sha256 = "0bkmw9rs7wzlycvih0ma97a3n1ly4x8cyv5c682rf3ykvnmkv1n1";
  };

  pt_BR = deriv {
    lang = "pt_BR";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-pt_BR-4.4.5.tar.bz2";
    sha256 = "1c4y5d7s2yvydnr0dmgnr0g871mblvkx0higzwivknd54nzf6fba";
  };

  ro = deriv {
    lang = "ro";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ro-4.4.5.tar.bz2";
    sha256 = "1lmz85a011m0f0cq7pj4ni2q3p3dzqqbgmii63hrn29ss4kvvkyw";
  };

  ru = deriv {
    lang = "ru";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-ru-4.4.5.tar.bz2";
    sha256 = "09ywm943k2v0cj3a82wrayi05m4gx2vvjff37v5hj4fxxw8785sv";
  };

  si = deriv {
    lang = "si";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-si-4.4.5.tar.bz2";
    sha256 = "0x3c9qp2crfghws0dckhjgjs3znvbj1pzllipj587snj2m43a1m8";
  };

  sk = deriv {
    lang = "sk";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-sk-4.4.5.tar.bz2";
    sha256 = "11dl6g4gyf62sxgxa1mpd6j78alkavsvqbjs46pv4jzl0c6z586z";
  };

  sl = deriv {
    lang = "sl";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-sl-4.4.5.tar.bz2";
    sha256 = "1p73g5bgyfzkfk8z6fi3kp2zs9hax4hwsf526hzs73v3z9prki9d";
  };

  sr = deriv {
    lang = "sr";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-sr-4.4.5.tar.bz2";
    sha256 = "1db60arnzpn9ca3zjnvfgx2sr5dw49w6z7ff6knpi88kzalv1w1i";
  };

  sv = deriv {
    lang = "sv";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-sv-4.4.5.tar.bz2";
    sha256 = "1ilpfca451xy6ls86l1pvd7srs3075h70kysyn1q4h9j18gfy03q";
  };

  tg = deriv {
    lang = "tg";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-tg-4.4.5.tar.bz2";
    sha256 = "0a0rvjqlvlzd99k1c04qmhkwg5814qcnjanx4dryqj5ridv2l2k1";
  };

  tr = deriv {
    lang = "tr";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-tr-4.4.5.tar.bz2";
    sha256 = "1im41dvwrf9bhk3yqprxbzjz7ark1kpc3bbix49c6fbmgkvfn2h5";
  };

  uk = deriv {
    lang = "uk";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-uk-4.4.5.tar.bz2";
    sha256 = "1ik51g3bgj4vvy3wzdnm7p2liwrkk3nrszydl7j2024fzj2vfyd2";
  };

  wa = deriv {
    lang = "wa";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-wa-4.4.5.tar.bz2";
    sha256 = "0mcv8rf54vxfq8ql4h8b573xdlw9x6j740zq7ki1qscvgrcj03g0";
  };

  zh_CN = deriv {
    lang = "zh_CN";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-zh_CN-4.4.5.tar.bz2";
    sha256 = "0w42x6dwnhz8668smgk3ld8bb7dvx60py4q7fj50qmipkb8vwh20";
  };

  zh_TW = deriv {
    lang = "zh_TW";
    url = "mirror://kde/stable/4.4.5/src/kde-l10n/kde-l10n-zh_TW-4.4.5.tar.bz2";
    sha256 = "19hvc57s37kpby1hjy6w5xi37a9n23rfxb53aj2lvdbar8ac9lci";
  };

}
