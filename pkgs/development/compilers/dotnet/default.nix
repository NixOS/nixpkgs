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

  # v2.2

  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1";

  # v3.0.2 (Maintenance)

  aspnetcore_3_0 = buildAspNetCore {
    version = "3.0.2";
    sha512 = "84dcc2a2a9e43afbc166771153d85b19cb09f964c85c787d77b362fd1d9e076345ae153305fa9040999846a56b69041eb89282804587478b926179d2613d259d";
  };

  netcore_3_0 = buildNetCore {
    version = "3.0.2";
    sha512 = "c8f0e4eb220fa896c4a803a8d9d0c704ae7b8383801a977036f3089b1d779159f5a2d9293dc11ff5f4f6c76febc6f70f6cfcdff0debd3243cad5eb635f853d45";
  };

  sdk_3_0 = buildNetCoreSdk {
    version = "3.0.102";
    sha512 = "77bc287d9c20630976ac4c0736192ba4899154c9e7cc5b87bc9d94d5d8abafdd832cfe8f385b6ba584c702d9261566109df15ab46b0d62bd218d950d3b47893e";
  };

  # v3.1.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.1";
    sha512 = "cc27828cacbc783ef83cc1378078e14ac558aec30726b36c4f154fad0d08ff011e7e1dfc17bc851926ea3b0da9c7d71496af14ee13184bdf503856eca30a89ae";
  };

  netcore_3_1 = buildNetCore {
    version = "3.1.1";
    sha512 = "991a89ac7b52d3bf6c00359ce94c5a3f7488cd3d9e4663ba0575e1a5d8214c5fcc459e2cb923c369c2cdb789a96f0b1dfb5c5aae1a04df6e7f1f365122072611";
  };

  sdk_3_1 = buildNetCoreSdk {
    version = "3.1.101";
    sha512 = "eeee75323be762c329176d5856ec2ecfd16f06607965614df006730ed648a5b5d12ac7fd1942fe37cfc97e3013e796ef278e7c7bc4f32b8680585c4884a8a6a1";
  };
}
