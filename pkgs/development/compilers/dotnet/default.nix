/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_2_2 sdk_3_0 sdk aspnetcore_2_1 ];
*/
{ callPackage
, stdenv }:
let
  buildDotnet = attrs: callPackage (import ./buildDotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; } );
  buildNetCore = attrs: buildDotnet (attrs // { type = "netcore"; } );
  buildNetCoreSdk = attrs: buildDotnet (attrs // { type = "sdk"; } );
in rec {
  combinePackages = attrs: callPackage (import ./combinePackages.nix attrs) {};

  # v2.1.15 (LTS)

  aspnetcore_2_1 = buildAspNetCore {
    version = "2.1.15";
    sha512 = if stdenv.isLinux
              then "a557f175cca92bb1dd66cf638ff84fe85750fab67028bd4472748b22ef0591f5f3812446a3dbe21c3d1be28c47d459d854d690dbace1b95bc7136b248af87334"
              else "1b87bgx1cwyilx8r32chlwv9f405i7mjwxj1630nvfwmm46iywi582did0al2jq9mkb8nafm0mh6b4mq7s7cxfjfvjksr7zhyx9axad";
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.15";
    sha512 = if stdenv.isLinux
              then "cfd7f7caea7e896dd4d68a05c827c86f38595f24e854edb3f934715ee1268e2623f17ff768215e465fe596cd474497384be2b1381f04ddd6d555665a341f65f6"
              else "0y22q7l5vw4nqzh43yax5kh3lbn34brn61chraazqnvq2qpdw6ij2cbm6f5jmcj2c6ssr6kgl7pz6b71mwm7bzf3kid4azrk9m3q28x";
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.803";
    sha512 = if stdenv.isLinux
              then "57d48d6ca1bd92ac348dc05220d984811c0cf005774d7afdfbbf125a842acb0a26572146ed25a7eb26f4e0404fe840b70d1e7ec1fb7c9a5c6cfe81fefc41b363"
              else "1ysg1frzf17s19v0vgr5wg3ilgain1pjs6hzym3bp2q8k8zh4vllydmlwlsb76lacyv638y95fcc74szb58dd9sl0yija1qhn84yhrq";
  };

  # v2.2

  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1";

  # v3.0.2 (Maintenance)

  aspnetcore_3_0 = buildAspNetCore {
    version = "3.0.2";
    sha512 = if stdenv.isLinux
              then "84dcc2a2a9e43afbc166771153d85b19cb09f964c85c787d77b362fd1d9e076345ae153305fa9040999846a56b69041eb89282804587478b926179d2613d259d"
              else "21k2qdbnai1sm3fl9y97hw8srnjpp83d50jhlbac62ack91v431g4hi35fmbahyy5b1l1svig0n7f8d4m7f0z4nfp9gmp2bw0xyvdz5";

  };

  netcore_3_0 = buildNetCore {
    version = "3.0.2";
    sha512 = if stdenv.isLinux
              then "c8f0e4eb220fa896c4a803a8d9d0c704ae7b8383801a977036f3089b1d779159f5a2d9293dc11ff5f4f6c76febc6f70f6cfcdff0debd3243cad5eb635f853d45"
              else "0214g5ylxki4f7lyfvwdd56f4a874kg2ycjzkx9vyad98590p74jwxqgwfnwd147f58py1s7xrj5k7rxw2z2p1nd4rlgy79gcqqpfnc";
  };

  sdk_3_0 = buildNetCoreSdk {
    version = "3.0.102";
    sha512 = if stdenv.isLinux
              then "77bc287d9c20630976ac4c0736192ba4899154c9e7cc5b87bc9d94d5d8abafdd832cfe8f385b6ba584c702d9261566109df15ab46b0d62bd218d950d3b47893e"
              else "25z8rkg00c8rnr0g4q26im4i3z65s1qvjxrsif98x16z77ii1mmlrfi50gd0fdz8ar032f5959pnnhd28nga4n2gyzhagd7v3qacsvy";
  };

  # v3.1.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.1";
    sha512 = if stdenv.isLinux
              then "cc27828cacbc783ef83cc1378078e14ac558aec30726b36c4f154fad0d08ff011e7e1dfc17bc851926ea3b0da9c7d71496af14ee13184bdf503856eca30a89ae"
              else "1sm0dr6azga748zzipwywpk0n5ccbckhpccdmj1n4w9gv174lbk1zm12201n68dis79asjvq1bnc17r7i8pz9ga6grkrxqn378knxs2";
  };

  netcore_3_1 = buildNetCore {
    version = "3.1.1";
    sha512 = if stdenv.isLinux
              then "991a89ac7b52d3bf6c00359ce94c5a3f7488cd3d9e4663ba0575e1a5d8214c5fcc459e2cb923c369c2cdb789a96f0b1dfb5c5aae1a04df6e7f1f365122072611"
              else "2w1i65ajfrxm05ijaiawiqb03yn8klz4q7k3p49f1gn5bcryz33m31045hd1h5s1g4djcwqkzv3xwqygp5k3qxwspih3dcjf2g6jsba";
  };

  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.101";
    sha512 = if stdenv.isLinux
             then "eeee75323be762c329176d5856ec2ecfd16f06607965614df006730ed648a5b5d12ac7fd1942fe37cfc97e3013e796ef278e7c7bc4f32b8680585c4884a8a6a1"
             else "1bs0p7jm5gaarc4ss6zfakzw03g0hf8vshlvjpdnxj9mjhssk45gv6h2jlamfkhb0w1a0i1y7j86w9haamwq62d3crg7dskdk76a25j";
  };
}
