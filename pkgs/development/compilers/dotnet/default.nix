/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_2_2 sdk_3_0 sdk aspnetcore_2_1 ];

Hashes below are retrived from:
https://dotnet.microsoft.com/download/dotnet
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
  buildNetCore = attrs: buildDotnet (attrs // { type = "netcore"; });
  buildNetCoreSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
rec {
  combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

  # v2.1.22 (LTS)

  aspnetcore_2_1 = buildAspNetCore {
    version = "2.1.22";
    sha512 = {
      x86_64-linux = "27v3a69dgnnb4lz5p2dn2qwadb8vpnqwdy6mnnqfp1dl4kgg3izvriz2268if272sy6flcz5lckjlmn0i0i1jci5zypc7x9kykj991l";
      aarch64-linux = null; # no aarch64 version of this package is available
      x86_64-darwin = "0xh06jmzx2cfq51hv9l4h72hbfyh3r0wlla217821gi0hlw6xcc0gb3b4xmqcs240fllqnwrnrwz0axi3xi21wacgn3xbcmzpbi6jml";
    };
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.22";
    sha512 = {
      x86_64-linux = "0c2b31l59izcxbhz5wzjpjkdl550s5p3aid4vyghq468vyf67pm0npjny50c172b63vw0ikfbps2b2hj16hpifp116gj4b5llmqjhyc";
      aarch64-linux = "3llai3d2xpgbr7a4ndg9wqfpnb5zb8k07dicc57a6cmniiqyqigyxinhpx2k0l45mbnihjsr5k1rih3r6bwlj241v67iwd2i0dpqd8a";
      x86_64-darwin = "106mx6a4rwcvq41v54c1yx89156s43n889im9g0q2pvm7054q8b6xm6qrnymzmj5i2i6awyk0z02j5pfiyh35sw9afxb3695ymsb3v8";
    };
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.810";
    sha512 = {
      x86_64-linux = "388nrba5f7z9syq23xh3k45rzy3iys58s32ya7a0q9mwdf1y3haw7yvbq79cn08741hhqdi73mip8jf50f4s64mbr62ay1p76zsrkj5";
      aarch64-linux = "2vs8bhk63cjrqkm5n164ahc6bdz58aq9vmhaiyy27krp7wlkz4gpiva9153h7mywhk709l1qc7cddj99qsh2ygv6axjfigbhgrzslqi";
      x86_64-darwin = "3qxlgbd0np0w8wmp98mhp4cqgva4zglqf7k9kzqbwxfwr5s795kap7rs5w0cy7h0bsvj0ygx3d5nzyn9hp3fsswx4jl4mkvillnvjzy";
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
    version = "3.1.8";
    sha512 = {
      x86_64-linux = "0i3dqsmh5x2aaagw30zvr0ydmzms5j6xvmwq0yx79r1hncw0zg8w1zq7cxvaddszl13d24wxb8vm4varkiv3fy8z3n2ndmhlqa2qcyw";
      aarch64-linux = "3f3xky7jqpqwnsg730ka1576ppsspi25xlqsrqmwlbanad0r89lidfppr34nsys9gb5f1vx1zkv73dn4jhl6yawnas9j9f8nhi5mq40";
      x86_64-darwin = "1gbiizljh80m9sqv4ynvch7si55if43f4ccfd9ynakwm777fddbg8py338l7irnxc5rid3xzw7c0yj5p8f22n38krlxkvr1zcwij68b";
    };
  };

  netcore_3_1 = buildNetCore {
    version = "3.1.8";
    sha512 = {
      x86_64-linux = "19gbb92lkfwmx4ic27v5g4cs8qzxiq8cv7sw9pxa8kibgr7lgifvg8dh3pd0i30a78yg5lc3fsdy0jal5i2k049nak72rfhxhrk5yxc";
      aarch64-linux = "0h0zfj82wafk6brmh35ah1qfxgxs4nm3wc47i14vhvkg78rz25w46rnah88zf9gkllnbhfxkw1ivcl4mm6l4ri9hv9367rr627hybvf";
      x86_64-darwin = "0zcp77lh6rvj1vlnjnnd9gqrwazn9v572l0x6r7b9pkjjq7fdh5cnjcc1cvkv9rb00mssd9jjv7yjdpv4i8i9hwby85g9bn500qx42c";
    };
  };

  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.402";
    sha512 = {
      x86_64-linux = "2zdb5cl4swg7kvnla6kgnnwg3kkb3rj2ccizg43fw89h8nacr1klz3zdl5km9l553lvm364dy8xsdwm79bw1ch0qgff6snnbbxlw5a2";
      aarch64-linux = "1aq8fhsn15362x99dfp72m67zbswrg30xscy1n983mmq76qn5ha6sy8pyj84l7qcs0n1b7akb77qyi3d2ns8bd2wl6s1dacl24gn10p";
      x86_64-darwin = "1gk6sgd9gdc6nr64mdfj6lhzdi6ixi5c1r0i1b7bhkg2xycx5cnbgjycrpqh17h6wbp68dz4mkg5hf1y3527hdwypa9k0sqdg3yrdb8";
    };
  };

  # v5.0.0

  aspnetcore_5_0 = buildAspNetCore {
    version = "5.0.0";
    sha512 = {
      x86_64-linux = "402046ee144915ef7d75a788cf19552eea56cf897681721b74bfc403fd366f71eb7e56f6b83ea299b6b812c6b87378c15e7bfe249415427dcd147dfeacd084d0";
      aarch64-linux = "13e174de1cf10135531468c2a76852de2c37253f4d8b487ff25d249c2d7a1c590475545ca246515338baff2950422ec6c5ffe2180e8327f25cb5f9fede696ccc";
      x86_64-darwin = "b47a9958f5412b22edb2cb47702ad442c389901ede3ca2a7f75d901f8ed608494431849f498c2191327065ff1db52a1658b1a8c0feb53aaec4c814fb0baf6818";
    };
  };

  net_5_0 = buildNetCore {
    version = "5.0.0";
    sha512 = {
      x86_64-linux = "d4d67df5ff5f6dde0d865a6e87559955bd57429df396cf7d05fe77f09e6220c67dc5e66439b1801ca4d301a62f81f666122bf4b623b31a46b861677dcafc62a4";
      aarch64-linux = "c7a5ae2bd4e0edbd3b681c2997ebf1633bfa1cd30a4333cb63fc9945b4e7c9278282516fb5bc22c710ce6fb59dc2e28230c07b0e99826165fa148406ab8afb0f";
      x86_64-darwin = "eba97211e158a0c1c15b03a79b42027319d83456dc377a2513c32defb560cd43fcfa1e84154a43243b77ca6b454c4dbc32be4153f0ba9c954c7b1e69ab5d7c53";
    };
  };

  sdk_5_0 = buildNetCoreSdk {
    version = "5.0.202";
    sha512 = {
      x86_64-linux = "Ae1Z8jYYSYdAVnPSSUDVXOKdgw59u8GVVv3AOJMDnmBGcS3m+QHcmREEeg3uT9FTGbfpT4ox32uYH6Nb2T2YOA==";
      aarch64-linux = "JuwSWgY35xrK0gOGR034mhAemulIkhtd4M00P0vA6EtOeyMY4Vl4cj6zudMh6Jt5DD8EJKQ8KbABX8byuePp2Q==";
      x86_64-darwin = "jxnfTbQUb0dJ2/NX2pu8Pi/F/e4EaDm2Ta5U+6sSYj/s6nNp6NHxtEn7BzhQ9/EVLszl/oXi3lL0d/BPbzldEA==";
    };
  };
}
