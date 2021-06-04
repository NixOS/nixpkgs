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
    version = "5.0.6";
    sha512 = {
      x86_64-linux = "07fd5ab0b62e3d68a3099b76e1236550d86a1ec24150a09284d37b58055786595b182662671f0d4602545bfa404da8be0f9ab96036352dca28dbfef0048bb22d";
      aarch64-linux = "40a09a9ff07b078cff17da6d0bfeb427c99c64f15135111831eef94c9d8c6274e9c5f3787c7b7652113e93af2547ed41b26b9d59fb55f28f9aa69cf90e804d0e";
      x86_64-darwin = "9e8ed066fe8c580e64355b85408cd5207655c87dc7095e7d5f9cbfed399f4bba037fa8e140d22184a6905fc89070a715af156afc7bc2207d5071a45bc47e7f55";
    };
  };

  net_5_0 = buildNetCore {
    version = "5.0.6";
    sha512 = {
      x86_64-linux = "7aece6b763305fcf6e47e31540830797670287622ec424e689967c8974f80cefdb04961fc8cdf23c67588f3b0804b5e8291f87b06b10f2fc83d48ce0b9700d38";
      aarch64-linux = "2f7e8b2654655d0d816e4d2e775098c340edf5edb458af9598f33a72e340268136fe6e2516ad4cfe941d0d419fe30357756f6585bcc151110e37c710284570d8";
      x86_64-darwin = "a14f8c65d87470daf9a6cd2c0e11bf0b0927440d14701f644faf2169e33498e82c833fd29b84192d7dc9fe6ea613a928f70100a262fc7094b02b82d304faea08";
    };
  };

  sdk_5_0 = buildNetCoreSdk {
    version = "5.0.300";
    sha512 = {
      x86_64-linux = "724a8e6ed77d2d3b957b8e5eda82ca8c99152d8691d1779b4a637d9ff781775f983468ee46b0bc8ad0ddbfd9d537dd8decb6784f43edae72c9529a90767310d2";
      aarch64-linux = "654e625627b35d9b8e4e5967c76485d0ff91769f5bb5429c99e0554c601426de1b26a5c37d32ab4bc227a15409c134757d5422944cf52c945b351c5927a28393";
      x86_64-darwin = "b3369628c2cab5e92954e3f78af0828321c15cab2fc2786d874e3dd3251d505c33dd65e7f7cbcd48c83ee81ae4ac6ff34439dd564980779b8b0f9790663d28a0";
    };
  };
}
