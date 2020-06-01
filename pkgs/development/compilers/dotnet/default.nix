/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_2_2 sdk_3_0 sdk aspnetcore_2_1 ];
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./buildDotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
  buildNetCore = attrs: buildDotnet (attrs // { type = "netcore"; });
  buildNetCoreSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
rec {
  combinePackages = attrs: callPackage (import ./combinePackages.nix attrs) {};

  # v2.1.15 (LTS)

  aspnetcore_2_1 = buildAspNetCore {
    version = "2.1.16";
    sha512 = {
      x86_64-linux = "0awdzi8dysbg8xcy4l8wx2sb8gaaklphmwv61qxh7dj6ih4nla34l02xdax1l8nw41znnnqzsa77avglnrz36pckm9mc52m7wc7877h";
      aarch64-linux = null; # no aarch64 version of this package is available
      x86_64-darwin = "1psqqpin4hipr2hzfp79712d6cag892jx4fx5001nlsynwrdq3vi4liakz4yz41rvk0jyd7f07z90wj97xlxyrqiqcc1fdbgn2q0px9";
    };
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.16";
    sha512 = {
      x86_64-linux = "07vvmza32hsblpw4zpcksm2gicy4agh0d1fwradqj16y6xbh3frdp87mqgbj5m54mmyfp5bc8c46v1w6dfm1w3y80v2y46aynild45l";
      aarch64-linux = "27ab982vz9rn2vzpq68dqfzhryfixq3s0apx7vi0cwiray3scgfmf45fm7qj63k9mvaqnk5g69i339109yasw3q5vpvpyjc1ykbi710";
      x86_64-darwin = "2pxqpcw3djr18m0y124fbd6pz4lb5brlgvpvd9pdirkpsar8dmipsrhxcsk0d902zyxzgj1ac1ygzxsz49xvrkmh6s1m3w5fk8fws2f";
    };
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.804";
    sha512 = {
      x86_64-linux = "1kbzxcdgyvs94kkm6ikr1j0p0k3zq30d10sl69ig0rgbqbqm4rpqi6dq94jjbw7q3jlwz83vgq3549q38d2s9kalmzv9lmddn2kkc42";
      aarch64-linux = "2d97xvhxnkdgghqlichkwdxxh641dzkd9hq5xgffgvbqv1qsh31k9yib2q1nsarpnbx0d758bdn2jm2wvsj7nx0gpxlb3nab0b3hc2g";
      x86_64-darwin = "0fjn18vizgfdbziklhgppnvka5iw2hb4pfi6047i46il8ydb6z1m40cflq436sdf07sivi0mnldg9247qvqrl6f078w3fwnh3bwlac8";
    };
  };

  # v2.2

  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1";

  # v3.0.2 (Maintenance)

  aspnetcore_3_0 = buildAspNetCore {
    version = "3.0.3";
    sha512 = {
      x86_64-linux = "342v6kxxbxky09d1c392vvr9rm30lf75wccka1bk2h4advlcga5nlgv93g7vrq48bsyxfi5gc36r3b0dlwl1g409g5mlk1042n6d0yq";
      aarch64-linux = "2xkg4q88q5jw6jdz6cxj8vsjr475nd0fcvifkv1shdm2j9dsjy233hwpxbr140m5n5ggyh6z99238z9j4kp2az977y8y8irz8m8ppvf";
      x86_64-darwin = "2p04j6p4j93pan71ih13hv57zxalcirh0n3vfjq0cfb80pbhf1f5cgxl24pw6kifh6hhh38rj62c4mr69lxzlqc8sfcfaws8dyz2avm";
    };
  };

  netcore_3_0 = buildNetCore {
    version = "3.0.3";
    sha512 = {
      x86_64-linux = "32ykpcw2xx708r2lxcwcbxnmy4sk159rlfjfvkw990qh7n79pm3lm2qwa3zhqcslznmpg18kwxz8qb5fgsa0h49g843xx4kyai0n7rx";
      aarch64-linux = "1lp8din7d5jv5fkyq1a7m01i1xg9jwpiljvam1kcyzsnwzvi0cb4ji336cfx4lqrn95gvc75gkzi6q8b4fz0h21gvk6z6kmlcr63nyg";
      x86_64-darwin = "0s20k7xawwd09xhy4xdcxp1rw6jd418ibrvhb509dnj480g48xryda2203g4mpswd24v2kx0n9qzxgbrbq9lvasfglkxi84bbqayp83";
    };
  };

  sdk_3_0 = buildNetCoreSdk {
    version = "3.0.103";
    sha512 = {
      x86_64-linux = "2diiplgxs92fkb6ym68b02d79z4qn63x5qlky5lvr757c1zkh0vfpk3khawdg94kdn4qkn6dmyqr0msxqgmiqyhp63cadzqq4vx7b12";
      aarch64-linux = "32843q2lj7dgciq62g9v1q31vwfjyv5vaxrz712d942mcg5lyzjygwri106bv4naq3a22131ldzwnsifbdn2vq1iz60raqdb7ss9vnf";
      x86_64-darwin = "3apswk2bhalgi0hm7h2j9p152jvp39h4xilxxzix5j1n36b442l1pwk7lj7019lxafjqkz5y850xkfcp14ks5wcvs33xs2c0aqwxvcn";
    };
  };

  # v3.1.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.2";
    sha512 = {
      x86_64-linux = "27708bk5liz8r39p4dzs41clgq298d49g8ipzdj56pz613vkfyv7bp91666ydz36aazm265j2g9ji3sk1f9kbgv6024zwrly5w9vqrm";
      aarch64-linux = "2sm5yf376w5dm0za3gbcj251kc909fmlasmlyn70zhqp2jiii075vcqh40racjlwlhsfydx32cw7kgnv238lad5mw5jxy143zql5xl3";
      x86_64-darwin = "311sihjzg0x5inyrz0px29jikxcibd6l56xfdmxkncgwaikf3663x10dfl246qhz8v0f3lvg2vndgp5icbaqrp8awsnrhsl0vi5d7fh";
    };
  };

  netcore_3_1 = buildNetCore {
    version = "3.1.2";
    sha512 = {
      x86_64-linux = "3zwg1anrcni9kagmjxn485bpjvb146hkm7irmikq3v879gjhd2fgpscg226ds83l4pxll3r7lwris6ij952xmy8lsqraapd9111ba14";
      aarch64-linux = "3hf61d5adlfffy51627ypp36qc5r55g9xwgfxqd0c7vj9bqmpiph673bvqqpr189df9shxr21p94cwrc5n36z72a37vw4ic8ks2yayx";
      x86_64-darwin = "35flr1p5zpcd77mjsl6qy9ipxc5k9j6pk7ca6mnvqqjf0r3agm3qf8cs5fbraprvkwj8fha3giwbp5xir6050fbb374375idn9x12d8";
    };
  };

  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.102";
    sha512 = {
      x86_64-linux = "0lmz8ac5j0i4zcq4904kr6qibvyjcm2ckfg27kqyqfii00qmm80xb5sk3i7f06xqkbgkrqkbg9rsldk75akw6m5dxg932j602bxrb4w";
      aarch64-linux = "34k6cm69gxm7vcd9m6bp47sdx96j32z6lfhb2vjcdznc6xgs2wy8zcang3b1mjm5919dq7v6iysm6ffcpgjhhphy7prlnaqa69q5mks";
      x86_64-darwin = "00xs87zj94v6yr6xs294bficp6lxpghyfswhnwqfkx62jy80qr5fa2y7s10ich3cbm2daa8dby56iizdvi7rnlvp23gfkq12gq4w1g8";
    };
  };
}
