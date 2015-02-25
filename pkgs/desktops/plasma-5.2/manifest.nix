# This file is generated automatically. DO NOT EDIT!
{ stdenv, fetchurl, mirror }:
[
  {
    name = stdenv.lib.nameFromURL "kwin-5.2.0.1.tar.xz" ".tar";
    store = "/nix/store/n6p747v05l1bs1l6802apii9wad8111v-kwin-5.2.0.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kwin-5.2.0.1.tar.xz";
      sha256 = "0jfzrhcnfi4v8qa0hcj0hmvjq0gd7ampq9qvl0s4bd3n6g92pn5f";
      name = "kwin-5.2.0.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ksshaskpass-5.2.0.tar.xz" ".tar";
    store = "/nix/store/gv341fwlrzw3svd2vr5b8wxcjk93r64v-ksshaskpass-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/ksshaskpass-5.2.0.tar.xz";
      sha256 = "17xjlb1gwxcdxzfadv0brr6ainnw25m681p013na182zigx9f9bv";
      name = "ksshaskpass-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kio-extras-5.2.0.tar.xz" ".tar";
    store = "/nix/store/iilra8kczb0waqigff390x2j2svkv5ba-kio-extras-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kio-extras-5.2.0.tar.xz";
      sha256 = "1c5qhp6axzbn5mla9q6qk0aalm0n4hvs6c4d9pclbcv58ysv3vw5";
      name = "kio-extras-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kmenuedit-5.2.0.tar.xz" ".tar";
    store = "/nix/store/4qcwcvnyqnpa6b7my8aqrp6v2zadz91m-kmenuedit-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kmenuedit-5.2.0.tar.xz";
      sha256 = "1qg7dh42lyp6mrckxjz07mmhk589d3wr080vljbm6hkgqm3aq7zr";
      name = "kmenuedit-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libbluedevil-5.2.0.tar.xz" ".tar";
    store = "/nix/store/d7nkh5p51ab5ag94yi3ggxjpbwn2k6g3-libbluedevil-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/libbluedevil-5.2.0.tar.xz";
      sha256 = "0s06kn9aqkyyfj1n6cb2hhnnqymwzljavfwj0f88mrkjrdf65bq9";
      name = "libbluedevil-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libkscreen-5.2.0.tar.xz" ".tar";
    store = "/nix/store/49pgxmxbn2qs5dzgf3iiwcaazj9ipiy3-libkscreen-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/libkscreen-5.2.0.tar.xz";
      sha256 = "1v75qi7b0m8fqdj5b38ypwgp1djkg408a4csn57y3pjgp7k69k53";
      name = "libkscreen-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kde-gtk-config-5.2.0.tar.xz" ".tar";
    store = "/nix/store/vf2cvrr4p7ydz36ir0cjd3p0yqa3cwpj-kde-gtk-config-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kde-gtk-config-5.2.0.tar.xz";
      sha256 = "1gafqrb5sg6jm4g3kivnwax05lq6gilzg8pc8k6dsnchyqzilbki";
      name = "kde-gtk-config-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdeplasma-addons-5.2.0.tar.xz" ".tar";
    store = "/nix/store/4qgb1w08k6ffyipfwbrj19pgpihg3pk7-kdeplasma-addons-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kdeplasma-addons-5.2.0.tar.xz";
      sha256 = "168bl9g1s9piy0bwrx7f8pbvn3jamw1rp90rihydamm3s54p1ykw";
      name = "kdeplasma-addons-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-desktop-5.2.0.tar.xz" ".tar";
    store = "/nix/store/sjqqnbp8s802rz6ydn3if77hr57njwpk-plasma-desktop-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/plasma-desktop-5.2.0.tar.xz";
      sha256 = "0xld7kxa8p78kw5f1a75nc0n69jn6vfp8nm40qqdhy2y3m5cc8p9";
      name = "plasma-desktop-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "systemsettings-5.2.0.tar.xz" ".tar";
    store = "/nix/store/b0pjfkpqsvfywawinn6a3q42r675q0gw-systemsettings-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/systemsettings-5.2.0.tar.xz";
      sha256 = "0yk1zn0kkjb9rcmqa2n10igcnk2fm06gfn7fgb4mcb2vjvv7a8y0";
      name = "systemsettings-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "polkit-kde-agent-1-5.2.0.tar.xz" ".tar";
    store = "/nix/store/ri0bgnblm2s7jsyvarvn0nrmnsgbv9wv-polkit-kde-agent-1-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/polkit-kde-agent-1-5.2.0.tar.xz";
      sha256 = "14b5z2ijlrv7h2bh6dxyd6r4qschzh1l2iqix63nbfa5nxyfc67q";
      name = "polkit-kde-agent-1-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "milou-5.2.0.tar.xz" ".tar";
    store = "/nix/store/gsmn9sv15f7iwk8hbh074rnm03ig5yhi-milou-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/milou-5.2.0.tar.xz";
      sha256 = "02gd7012zbiaxhb6wliapfcb4spjrdgnhvhl3y64ixqrx2b032a5";
      name = "milou-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kinfocenter-5.2.0.tar.xz" ".tar";
    store = "/nix/store/xfnj3gy03ynfaazy82gkxijm9fykwk4x-kinfocenter-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kinfocenter-5.2.0.tar.xz";
      sha256 = "151flq4w6m94jgfrzbf3w3v11xybx92xd0nv0bdh5vvaxg97dac9";
      name = "kinfocenter-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdecoration-5.2.0.tar.xz" ".tar";
    store = "/nix/store/dqqb6cvwcd43yanifka0kmx1pdhryjcj-kdecoration-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kdecoration-5.2.0.tar.xz";
      sha256 = "135i1maqp0q9aa312l0dqfkmxjq12mri2zjwg03wzgmmy5b9wm52";
      name = "kdecoration-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kde-cli-tools-5.2.0.tar.xz" ".tar";
    store = "/nix/store/zfnbl0kbh4x3lpalc7irjgynl53mcf52-kde-cli-tools-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kde-cli-tools-5.2.0.tar.xz";
      sha256 = "0lr3ir8kfq1x0yn0ahhlks0ikxxqbyj6jdmkdlr8hz5ivcpr64mq";
      name = "kde-cli-tools-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kscreen-5.2.0.tar.xz" ".tar";
    store = "/nix/store/w2gq2s7lgf637qn0f5a0dh06i7mkjhki-kscreen-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kscreen-5.2.0.tar.xz";
      sha256 = "09f77vszpni93ahm31gsb7lg4lidchppa1kd9s8q98yf2rb9hl55";
      name = "kscreen-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-workspace-wallpapers-5.2.0.tar.xz" ".tar";
    store = "/nix/store/3rzwgwlzbmin9sjpp614bavjmrqqwk9x-plasma-workspace-wallpapers-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/plasma-workspace-wallpapers-5.2.0.tar.xz";
      sha256 = "1xb500w5y9jn6xyayw5v28qsy6xp0pfb3ydciga77h1xd59wp0ym";
      name = "plasma-workspace-wallpapers-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "sddm-kcm-5.2.0.tar.xz" ".tar";
    store = "/nix/store/q3wbyymqnxwcv9c58fxc4fg2c6pc2d5r-sddm-kcm-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/sddm-kcm-5.2.0.tar.xz";
      sha256 = "0ds4qlgwzbpa32w3mlhf64p64n1jifm6797v6jb5v3qjnamlpk96";
      name = "sddm-kcm-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libksysguard-5.2.0.tar.xz" ".tar";
    store = "/nix/store/n50iq06yz6z2n2n7wh10ww7cks22zz4z-libksysguard-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/libksysguard-5.2.0.tar.xz";
      sha256 = "0jfyy90zdajpxy5yy9w14n8r8jx7d6bdwss7h8rrkp5zljp9nzwp";
      name = "libksysguard-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "oxygen-5.2.0.tar.xz" ".tar";
    store = "/nix/store/60kb2hhwlmykfx5mc2s8hyd8zh6ngrpv-oxygen-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/oxygen-5.2.0.tar.xz";
      sha256 = "1wad5m36h31y99v4gwx19n3k14xxc0hvp9c4n3g67fyy8pjnr0ax";
      name = "oxygen-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "khelpcenter-5.2.0.tar.xz" ".tar";
    store = "/nix/store/dfi8w8dsk5cxbyhm5kznja6kxda23n8j-khelpcenter-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/khelpcenter-5.2.0.tar.xz";
      sha256 = "1a5z2bvxjdwp81jnyrdf7q591k6ql504argl7lg3pbvph08rc0rs";
      name = "khelpcenter-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "baloo-5.6.0.tar.xz" ".tar";
    store = "/nix/store/sgm5dcgmw5cwz60hhhqnlgxq1ck1cffh-baloo-5.6.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/baloo-5.6.0.tar.xz";
      sha256 = "1py0npkf8s46zwbg23cn49f777fc9cid1njg8crc8h71md71j614";
      name = "baloo-5.6.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-workspace-5.2.0.tar.xz" ".tar";
    store = "/nix/store/g2ar4zpsc36zalpd5frzdpxscgzg727b-plasma-workspace-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/plasma-workspace-5.2.0.tar.xz";
      sha256 = "1swii172mv32837kgcxnmafs1blpgpdn6hda07f1aanaz4scxvj3";
      name = "plasma-workspace-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwrited-5.2.0.tar.xz" ".tar";
    store = "/nix/store/r5qz9f2s7q0i00lsp86fv1b500cr2x0n-kwrited-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kwrited-5.2.0.tar.xz";
      sha256 = "0rg1ml7m6f2kql4qi9pg8dd66hr7rxqgyjg3rs66diibz383cjzb";
      name = "kwrited-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libmm-qt-5.2.0.tar.xz" ".tar";
    store = "/nix/store/6fzkxwzqysgwjzmiyg16fdasp64gik52-libmm-qt-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/libmm-qt-5.2.0.tar.xz";
      sha256 = "07flvspy3qs2mhjxnwy3l8giw296p3501ad1hr3bnjidm2iykc6s";
      name = "libmm-qt-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-nm-5.2.0.tar.xz" ".tar";
    store = "/nix/store/9n79gfai09ydrjf12ckqviqaf5jkwar8-plasma-nm-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/plasma-nm-5.2.0.tar.xz";
      sha256 = "0br2mqx8g660jcs1hiwssg6fdiddn4zk78kdmcgkpq93y5ysdf5c";
      name = "plasma-nm-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwayland-5.2.0.tar.xz" ".tar";
    store = "/nix/store/jidv4bi8f2iyg3zhdqip5f7lkwmgav94-kwayland-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kwayland-5.2.0.tar.xz";
      sha256 = "1w872ask0w9gbw46dx3si124gmzkapj7naysgrb5zdcdf8avcgqy";
      name = "kwayland-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ksysguard-5.2.0.tar.xz" ".tar";
    store = "/nix/store/s4xb576g8hjpl39ysbmzlsw19a99zssy-ksysguard-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/ksysguard-5.2.0.tar.xz";
      sha256 = "0kd103kzxgsgrrhfjacy50gg6wsvqa9ix9xk5nb59bbdzj0b4km1";
      name = "ksysguard-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kfilemetadata-5.6.0.tar.xz" ".tar";
    store = "/nix/store/rvjxs89p415z52nhzrmci6s91nb0fy5a-kfilemetadata-5.6.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kfilemetadata-5.6.0.tar.xz";
      sha256 = "0vg9lc6d2q6bx53lixcmdhfgwqqr3hfl6g3pvgss237kd3fbb94n";
      name = "kfilemetadata-5.6.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "bluedevil-5.2.0.tar.xz" ".tar";
    store = "/nix/store/w4s1zfgmallmqq400pvh6zy9qrss6206-bluedevil-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/bluedevil-5.2.0.tar.xz";
      sha256 = "01a3h0jp9nq9fs1zv4wp7jgmpv4nscflb3nkz93dg0g1bis1kgnh";
      name = "bluedevil-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "breeze-5.2.0.tar.xz" ".tar";
    store = "/nix/store/yyq50zwlb2xxahkb6w0zvz41rz2gg4k1-breeze-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/breeze-5.2.0.tar.xz";
      sha256 = "1s8381nhszb2d7b0r6rmngnkgw28xxsfhnginbcb6zkljgprnkkh";
      name = "breeze-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "oxygen-fonts-5.2.0.tar.xz" ".tar";
    store = "/nix/store/96is0p4rp0nqv9yllqrk9xhv4fa86gan-oxygen-fonts-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/oxygen-fonts-5.2.0.tar.xz";
      sha256 = "102hycnk4naysmyj87mv1sm41aq214f3wjzzi429r0i135wdblki";
      name = "oxygen-fonts-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "powerdevil-5.2.0.tar.xz" ".tar";
    store = "/nix/store/lqny6rqbrgpadkm6d1s52i9959zwhjh8-powerdevil-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/powerdevil-5.2.0.tar.xz";
      sha256 = "1mi60xn4pgwrq4w3i45gxqjqqfwjxzkkyx89fkwwj1xv68bkwshs";
      name = "powerdevil-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "muon-5.2.0.tar.xz" ".tar";
    store = "/nix/store/f7i8c6ig71506aqcmj3mp8yapyid5zki-muon-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/muon-5.2.0.tar.xz";
      sha256 = "15vcrm7y5khpc0rngzqbhizg2w0rz6adf5v3cpwafmqaq3iqlcb7";
      name = "muon-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "khotkeys-5.2.0.tar.xz" ".tar";
    store = "/nix/store/6sqh6vy8i8xg5xqh0b2ic1a3wb1nv2p8-khotkeys-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/khotkeys-5.2.0.tar.xz";
      sha256 = "187757g70wjq1v9r7nf3fxc6233sb5m28s4aswlm7rjvys5lmkch";
      name = "khotkeys-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwin-5.2.0.tar.xz" ".tar";
    store = "/nix/store/hrv9ikwphl3mg8sk6i8b9q3wj5ca24ni-kwin-5.2.0.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.0/kwin-5.2.0.tar.xz";
      sha256 = "0ys76xllgr2034bxpr5m1qm5v8qp8wnzn09f6gghcvnm3lqki79q";
      name = "kwin-5.2.0.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kio-extras-5.2.1.tar.xz" ".tar";
    store = "/nix/store/79invr6hmjir390chxkbqwijfl47sn44-kio-extras-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kio-extras-5.2.1.tar.xz";
      sha256 = "0b410hrwpanshvnr3qsgcpza142d178nr3hsgb0r0ssfh0wycmm8";
      name = "kio-extras-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kde-gtk-config-5.2.1.tar.xz" ".tar";
    store = "/nix/store/wp46hfmfna4343jryqnxgkx0i73w206m-kde-gtk-config-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kde-gtk-config-5.2.1.tar.xz";
      sha256 = "0d1ll4wx1wr14rczjmzxpfiwp67i0ljn172c9w8vhvrv7gy579vw";
      name = "kde-gtk-config-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "oxygen-5.2.1.tar.xz" ".tar";
    store = "/nix/store/qsi6ridvxykn2qpdq6h8s85dcnn04l1a-oxygen-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/oxygen-5.2.1.tar.xz";
      sha256 = "1aj9y24ii51av8ydkk07nj666xk6igqkqqhlcpcc513qy87l041l";
      name = "oxygen-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "khotkeys-5.2.1.tar.xz" ".tar";
    store = "/nix/store/98gn6w9nnzl0901dgs7kzm9j5kgf9i75-khotkeys-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/khotkeys-5.2.1.tar.xz";
      sha256 = "012hnykqwx4asmbsd84kqzrq90bwkpryh7nribpsc99kwlngdgsn";
      name = "khotkeys-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-desktop-5.2.1.tar.xz" ".tar";
    store = "/nix/store/ndkx7f2agaxdgn0l8yz9p3a0ahkhbyy8-plasma-desktop-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/plasma-desktop-5.2.1.tar.xz";
      sha256 = "08pjyvb8lzjd0pmc72k8c6jcgprzq0g8psd5vhmvw614j9pz1a5d";
      name = "plasma-desktop-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "baloo-5.6.1.tar.xz" ".tar";
    store = "/nix/store/qjcgng89qgribr5np0vrvj86jvvprsg4-baloo-5.6.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/baloo-5.6.1.tar.xz";
      sha256 = "1agf2vqkx9hb95di99c65752q9wjnyhkz1iwwvyk1n1a7jzvdqf2";
      name = "baloo-5.6.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "sddm-kcm-5.2.1.tar.xz" ".tar";
    store = "/nix/store/g5lazmji9vlyiqkl6sj8h6i0yzdgnx1k-sddm-kcm-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/sddm-kcm-5.2.1.tar.xz";
      sha256 = "0jjis582j1rk8ss64ys94izsg29sik0khv3czzw5zjqns22kn2r3";
      name = "sddm-kcm-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "powerdevil-5.2.1.tar.xz" ".tar";
    store = "/nix/store/dv4cbwkmvpinz0v3s9y6p0ifci0q5fh0-powerdevil-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/powerdevil-5.2.1.tar.xz";
      sha256 = "147hpzwmw0vxysp7wv0fhmrgaw1aclap70ii7i5pz05k093xngfm";
      name = "powerdevil-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-workspace-wallpaper-5.2.1.tar.xz" ".tar";
    store = "/nix/store/mfchg5yspiyzvhhp5qh6j3zwfnwpca70-plasma-workspace-wallpaper-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/plasma-workspace-wallpaper-5.2.1.tar.xz";
      sha256 = "0cr6s3rs2gz8cq93q7l2w2g0ibzqqlyh0v1nkzhpyxqq0vggjliw";
      name = "plasma-workspace-wallpaper-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libbluedevil-5.2.1.tar.xz" ".tar";
    store = "/nix/store/iwiksm38d0ywn3x4rvcfjiynknxmy628-libbluedevil-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/libbluedevil-5.2.1.tar.xz";
      sha256 = "1wqk03pxl2bzy4f77fy1zwlrlv3k96x9xz8qnavkir9j0i3ijndp";
      name = "libbluedevil-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kfilemetadata-5.6.1.tar.xz" ".tar";
    store = "/nix/store/m3f02ph2gqj8zw3p1kq86ih6m423i670-kfilemetadata-5.6.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kfilemetadata-5.6.1.tar.xz";
      sha256 = "0w6dzhng4wp4mrxnq6859np6j3h9iydj4dscp1qr3zc0y377blw3";
      name = "kfilemetadata-5.6.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "milou-5.2.1.tar.xz" ".tar";
    store = "/nix/store/f5979rdy20yxjbh9qif3wf7sylhdfr5i-milou-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/milou-5.2.1.tar.xz";
      sha256 = "1q5bfw7wbgq3gz5r3sdvx7rmsf4cbj501cy1asl6bf1grshjqiyn";
      name = "milou-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ksysguard-5.2.1.tar.xz" ".tar";
    store = "/nix/store/6llw96fvpb79s3482w0v3ahb6qzn8czi-ksysguard-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/ksysguard-5.2.1.tar.xz";
      sha256 = "06sr86siw43ly1c8iqjd672szxxjqxl6n8gnxmf92h3qqh1i8a2k";
      name = "ksysguard-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kmenuedit-5.2.1.tar.xz" ".tar";
    store = "/nix/store/fka4bg5h2hz93knjv2kqvz62dg5pk805-kmenuedit-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kmenuedit-5.2.1.tar.xz";
      sha256 = "0kpfxgm8jfm2lyf7wxmnnl9flligmds8f6fy1cy36fqxpzhcal98";
      name = "kmenuedit-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "systemsettings-5.2.1.tar.xz" ".tar";
    store = "/nix/store/942knn924cz51wwn3jimhcp799zlc7c8-systemsettings-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/systemsettings-5.2.1.tar.xz";
      sha256 = "0ib84irgdbjd3sga7csjx59c2wxg34yr3j9a8ajhqvdq34yb14n4";
      name = "systemsettings-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "muon-5.2.1.tar.xz" ".tar";
    store = "/nix/store/fvq7swhq8343kr70vjsl11bv1c3ayw3k-muon-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/muon-5.2.1.tar.xz";
      sha256 = "115a7q2ns0h6lszn1lq84y5bk02fm4ly3alxkig7976jh8rbykxf";
      name = "muon-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-nm-5.2.1.tar.xz" ".tar";
    store = "/nix/store/igw2v8zgczarw9ynxf473mfl76y6wd4j-plasma-nm-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/plasma-nm-5.2.1.tar.xz";
      sha256 = "1c4gkxv24kdl2b5gslljihwh5h0v970f70802swblgrp87819bfj";
      name = "plasma-nm-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libksysguard-5.2.1.tar.xz" ".tar";
    store = "/nix/store/zkrwgpjsa2761wpmic225szjs4503kss-libksysguard-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/libksysguard-5.2.1.tar.xz";
      sha256 = "0f0s3hafdvgvscfbvkkdll95rzxa44j89qm7cmsclaqclmnwcfa2";
      name = "libksysguard-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "polkit-kde-agent-1-5.2.1.tar.xz" ".tar";
    store = "/nix/store/gsni5ny5qx2j1vic0q1pa0xb0126x2z0-polkit-kde-agent-1-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/polkit-kde-agent-1-5.2.1.tar.xz";
      sha256 = "0scmsiwwmmz1by8yzh5waa8ngp13hk7yihxh0bf0mfph8zkv3jf4";
      name = "polkit-kde-agent-1-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwin-5.2.1.tar.xz" ".tar";
    store = "/nix/store/n8bydi50mqc41sxh95v1zyncfh157am1-kwin-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kwin-5.2.1.tar.xz";
      sha256 = "1cp7rak0y7jjizj9ampx2wcvra0kffxjs7grd2j57s4qy3z9az6i";
      name = "kwin-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-workspace-wallpapers-5.2.1.tar.xz" ".tar";
    store = "/nix/store/cmrfclyx47g0byimi9fk2vgc92mi8vjd-plasma-workspace-wallpapers-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/plasma-workspace-wallpapers-5.2.1.tar.xz";
      sha256 = "0dhbwygbxzjxzklcrqa2429k1harl9gz33l9183bz3q62iwcxf0x";
      name = "plasma-workspace-wallpapers-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "bluedevil-5.2.1.tar.xz" ".tar";
    store = "/nix/store/5mj21ln4sm2i32xbhzbadjhgxhig0fjs-bluedevil-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/bluedevil-5.2.1.tar.xz";
      sha256 = "1jahp2a8v4hmar8qfiw04miiih5br5s3jpkqlqmmpc56vn1czx6m";
      name = "bluedevil-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kinfocenter-5.2.1.tar.xz" ".tar";
    store = "/nix/store/cww4i8a48yhm0mddak67lqy9lld20wy3-kinfocenter-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kinfocenter-5.2.1.tar.xz";
      sha256 = "141mkk1gnhmnxxk0j1mn4p5zzwyjkbbwmwbpqq2adaar18p917i8";
      name = "kinfocenter-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kscreen-5.2.1.tar.xz" ".tar";
    store = "/nix/store/h65gaypalzzqfgq3vcc495cdan9k4p5v-kscreen-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kscreen-5.2.1.tar.xz";
      sha256 = "164vwvqrvzjczg2nbi9wkpnk8yki240iz2h5j50n5gkqvgg0w7df";
      name = "kscreen-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "oxygen-fonts-5.2.1.tar.xz" ".tar";
    store = "/nix/store/hlcr09wkzjs62vwawsi9d611n0gxrixp-oxygen-fonts-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/oxygen-fonts-5.2.1.tar.xz";
      sha256 = "0xnhh135yihmv40imd3mibwzcfdxgbn1mk4rjrsj5fqni113f0lm";
      name = "oxygen-fonts-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libkscreen-5.2.1.tar.xz" ".tar";
    store = "/nix/store/6xs5v03w12rmqpz235sk9scxap51s2db-libkscreen-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/libkscreen-5.2.1.tar.xz";
      sha256 = "0i7vm73gs1f715fnmacrdnvk1hij03d72fr70wwa3x18cdcg4qas";
      name = "libkscreen-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "breeze-5.2.1.tar.xz" ".tar";
    store = "/nix/store/8sr3b4ah8ds74wgfna9zcnq6vm5s3kn3-breeze-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/breeze-5.2.1.tar.xz";
      sha256 = "0qdps15mr897s2pcjdci4nyg81n3j90ksz7jybqfkd0gr9l14iy5";
      name = "breeze-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "libmm-qt-5.2.1.tar.xz" ".tar";
    store = "/nix/store/cgj3wzm22izb1hvbx3wdd18zw3wswgil-libmm-qt-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/libmm-qt-5.2.1.tar.xz";
      sha256 = "0n3q4bgj4ijrx7hdrnbbhxfnw4w97vgj5ba341qwf89hkhc4dhwn";
      name = "libmm-qt-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwrited-5.2.1.tar.xz" ".tar";
    store = "/nix/store/l3swq17a373a0z131mvqn4xa0nwsvjp5-kwrited-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kwrited-5.2.1.tar.xz";
      sha256 = "006y89c7pxzc55lrkjrvyrywj4j95641n3j0b5vjr2mgxcnv8q7a";
      name = "kwrited-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdeplasma-addons-5.2.1.tar.xz" ".tar";
    store = "/nix/store/06vk8iv3k4xb96rghh6jva6zj8q9a7ha-kdeplasma-addons-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kdeplasma-addons-5.2.1.tar.xz";
      sha256 = "1lfb6f5h1qjbl0zyqw5q98b27hw16lszyk1nacgncp3ig1y177r3";
      name = "kdeplasma-addons-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "ksshaskpass-5.2.1.tar.xz" ".tar";
    store = "/nix/store/fydms9jaal65yga60hngnz7hmz268wi2-ksshaskpass-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/ksshaskpass-5.2.1.tar.xz";
      sha256 = "18wa7naxv7g7zrrkrbh9iljd4h479cq6xmair5iqc0cbbfw7znm0";
      name = "ksshaskpass-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kde-cli-tools-5.2.1.tar.xz" ".tar";
    store = "/nix/store/1rm663f8mdif77m0wrkib534yskj0g6n-kde-cli-tools-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kde-cli-tools-5.2.1.tar.xz";
      sha256 = "0zxrn1j4lmlj0s6j5245sd0ykg9wa93i0d8qzca4rjxn5mh87v9q";
      name = "kde-cli-tools-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kdecoration-5.2.1.tar.xz" ".tar";
    store = "/nix/store/06pjfn5j8lwbd7dj808mjs2bsfwbc3hr-kdecoration-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kdecoration-5.2.1.tar.xz";
      sha256 = "0910hgh64xbap213sjj1bbxwmibi74chdyyp2qc149f5anqs3fcy";
      name = "kdecoration-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "kwayland-5.2.1.tar.xz" ".tar";
    store = "/nix/store/03np6kr81s99j3ijzq236ywc8nkxpy0j-kwayland-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/kwayland-5.2.1.tar.xz";
      sha256 = "1c7h9csiam65jkrlg81iqi9y7q3mf63af87zkf6nfalbmz6j0p8l";
      name = "kwayland-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "khelpcenter-5.2.1.tar.xz" ".tar";
    store = "/nix/store/2ws6508gv1m375l4xcyf6pa8q5c26748-khelpcenter-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/khelpcenter-5.2.1.tar.xz";
      sha256 = "17sl0va35p420s8lmyz1pzyhzmrssvakc3w06xjj7f6hvgh8iqxw";
      name = "khelpcenter-5.2.1.tar.xz";
    };
  }
  {
    name = stdenv.lib.nameFromURL "plasma-workspace-5.2.1.tar.xz" ".tar";
    store = "/nix/store/04b1cp5432y80dl8a55xy4nvw586f33c-plasma-workspace-5.2.1.tar.xz";
    src = fetchurl {
      url = "${mirror}/stable/plasma/5.2.1/plasma-workspace-5.2.1.tar.xz";
      sha256 = "0ldls1q5f88imc4cvxizssizswfgalh9ix95ab7p5f6ylizagp63";
      name = "plasma-workspace-5.2.1.tar.xz";
    };
  }
]
