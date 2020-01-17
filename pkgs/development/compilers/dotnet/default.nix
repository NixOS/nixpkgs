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

  sdk_2_2 = buildNetCoreSdk {
    version = "2.2.401";
    sha512 = "05w3zk7bcd8sv3k4kplf20j906and2006g1fggq7y6kaxrlhdnpd6jhy6idm8v5bz48wfxga5b4yys9qx0fp3p8yl7wi67qljpzrq88";
  };
}
