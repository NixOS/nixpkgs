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

  aspnetcore_2_1 = buildAspNetCore {
    version = "2.1.13";
    sha512 = "0i9r9pq9avixv08vwcp796kdwplz90lip07y4f50s0jqwpww070qsydplnv3pixi9dfn4s169qd97c7km3qs1snvn9yasigg1vv2wqx";
  };

  netcore_2_1 = buildNetCore {
    version = "2.1.13";
    sha512 = "2gkawhm4vk74qmdlpa9128brirwqxpa1b6w8jmcyd6j4i8lpnkp83jhmjjrjr4jdihchapp8qxb7sa1qdj21yswbpn03n86g8l3gh0h";
  };

  sdk_2_1 = buildNetCoreSdk {
    version = "2.1.509";
    sha512 = "4B7DC25841F56AADDD685ADB227B362177268E3D052B4ADDDAC2530889B6506B7B4768B751AE75F131143424D02EEE77B4565DAD6B49048C39D2C47E39412FDF";
  };
  sdk_2_2 = buildNetCoreSdk {
    version = "2.2.401";
    sha512 = "05w3zk7bcd8sv3k4kplf20j906and2006g1fggq7y6kaxrlhdnpd6jhy6idm8v5bz48wfxga5b4yys9qx0fp3p8yl7wi67qljpzrq88";
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
