/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_2_2 sdk_3_0 sdk aspnetcore_2_1 ];
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./buildDotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; } );
  buildNetCore = attrs: buildDotnet (attrs // { type = "netcore"; } );
  buildNetCoreSdk = attrs: buildDotnet (attrs // { type = "sdk"; } );
in rec {
  combinePackages = attrs: callPackage (import ./combinePackages.nix attrs) {};

  # v2.1.15 (LTS)

  aspnetcore_2_1 = buildAspNetCore {
    version = "2.1.16";
    sha512 = "0awdzi8dysbg8xcy4l8wx2sb8gaaklphmwv61qxh7dj6ih4nla34l02xdax1l8nw41znnnqzsa77avglnrz36pckm9mc52m7wc7877h";
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.16";
    sha512 = "07vvmza32hsblpw4zpcksm2gicy4agh0d1fwradqj16y6xbh3frdp87mqgbj5m54mmyfp5bc8c46v1w6dfm1w3y80v2y46aynild45l";
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.804";
    sha512 = "1kbzxcdgyvs94kkm6ikr1j0p0k3zq30d10sl69ig0rgbqbqm4rpqi6dq94jjbw7q3jlwz83vgq3549q38d2s9kalmzv9lmddn2kkc42";
  };

  # v2.2

  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1";

  # v3.0.2 (Maintenance)

  aspnetcore_3_0 = buildAspNetCore {
    version = "3.0.3";
    sha512 = "342v6kxxbxky09d1c392vvr9rm30lf75wccka1bk2h4advlcga5nlgv93g7vrq48bsyxfi5gc36r3b0dlwl1g409g5mlk1042n6d0yq";
  };

  netcore_3_0 = buildNetCore {
    version = "3.0.3";
    sha512 = "32ykpcw2xx708r2lxcwcbxnmy4sk159rlfjfvkw990qh7n79pm3lm2qwa3zhqcslznmpg18kwxz8qb5fgsa0h49g843xx4kyai0n7rx";
  };

  sdk_3_0 = buildNetCoreSdk {
    version = "3.0.103";
    sha512 = "2diiplgxs92fkb6ym68b02d79z4qn63x5qlky5lvr757c1zkh0vfpk3khawdg94kdn4qkn6dmyqr0msxqgmiqyhp63cadzqq4vx7b12";
  };

  # v3.1.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.2";
    sha512 = "27708bk5liz8r39p4dzs41clgq298d49g8ipzdj56pz613vkfyv7bp91666ydz36aazm265j2g9ji3sk1f9kbgv6024zwrly5w9vqrm";
  };

  netcore_3_1 = buildNetCore {
    version = "3.1.2";
    sha512 = "3zwg1anrcni9kagmjxn485bpjvb146hkm7irmikq3v879gjhd2fgpscg226ds83l4pxll3r7lwris6ij952xmy8lsqraapd9111ba14";
  };

  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.102";
    sha512 = "0lmz8ac5j0i4zcq4904kr6qibvyjcm2ckfg27kqyqfii00qmm80xb5sk3i7f06xqkbgkrqkbg9rsldk75akw6m5dxg932j602bxrb4w";
  };
}
