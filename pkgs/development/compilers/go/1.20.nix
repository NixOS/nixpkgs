{ stdenv
, callPackage
, substituteAll
, tzdata
, iana-etc
, mailcap
, buildPackages
, buildGo120Module
, Security
, Foundation
, xcbuild
}:

let
  buildGo = callPackage ./generic.nix {
    buildGoModule = buildGo120Module;
    inherit Security Foundation xcbuild;
  };

  useGccGoBootstrap = stdenv.buildPlatform.isMusl || stdenv.buildPlatform.isRiscV;
  goBootstrap = if useGccGoBootstrap then buildPackages.gccgo12 else buildPackages.callPackage ./bootstrap117.nix { };
in
buildGo {
  inherit useGccGoBootstrap goBootstrap;
  version = "1.20.8";
  hash = "sha256-ONcXFPpSeflyQEUZVtjkfjwbal3ny4QTeUnWK13TGC4=";
  patches = [
    (substituteAll {
      src = ./iana-etc-1.17.patch;
      iana = iana-etc;
    })
    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    (substituteAll {
      src = ./mailcap-1.17.patch;
      inherit mailcap;
    })
    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    (substituteAll {
      src = ./tzdata-1.19.patch;
      inherit tzdata;
    })
    ./remove-tools-1.11.patch
    ./go_no_vendor_checks-1.16.patch
  ];
}
