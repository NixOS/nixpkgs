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
    version = "2.1.15";
    sha512 = "a557f175cca92bb1dd66cf638ff84fe85750fab67028bd4472748b22ef0591f5f3812446a3dbe21c3d1be28c47d459d854d690dbace1b95bc7136b248af87334";
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.15";
    sha512 = "cfd7f7caea7e896dd4d68a05c827c86f38595f24e854edb3f934715ee1268e2623f17ff768215e465fe596cd474497384be2b1381f04ddd6d555665a341f65f6";
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.803";
    sha512 = "57d48d6ca1bd92ac348dc05220d984811c0cf005774d7afdfbbf125a842acb0a26572146ed25a7eb26f4e0404fe840b70d1e7ec1fb7c9a5c6cfe81fefc41b363";
  };

  # v3.0.2 (Maintenance)

  aspnetcore_3_0 = buildAspNetCore {
    version = "3.0.2";
    sha512 = "84dcc2a2a9e43afbc166771153d85b19cb09f964c85c787d77b362fd1d9e076345ae153305fa9040999846a56b69041eb89282804587478b926179d2613d259d";
  };

  sdk_3_0 = buildNetCoreSdk {
    version = "3.0.100";
    sha512 = "766da31f9a0bcfbf0f12c91ea68354eb509ac2111879d55b656f19299c6ea1c005d31460dac7c2a4ef82b3edfea30232c82ba301fb52c0ff268d3e3a1b73d8f7";
  };
  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.100";
    sha512 = "0hvshwsgbm6v5hc1plzdzx8bwsdna2167fnfhxpysqs5mz7crsa4f13m4cxhrbn64lasqz2007nhdrlpgaqvgll6q8736h884aaw5sj";
  };
}
