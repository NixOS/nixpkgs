{ stdenv
, callPackage
, fetchpatch
, substituteAll
, tzdata
, iana-etc
, mailcap
, buildPackages
, buildGo118Module
, Security
, Foundation
, xcbuild
}:

let
  buildGo = callPackage ./generic.nix {
    buildGoModule = buildGo118Module;
    inherit Security Foundation xcbuild;
  };

  useGccGoBootstrap = stdenv.buildPlatform.isMusl || stdenv.buildPlatform.isRiscV;
  goBootstrap = if useGccGoBootstrap then buildPackages.gccgo12 else buildPackages.callPackage ./bootstrap116.nix { };
in
buildGo {
  inherit useGccGoBootstrap goBootstrap;
  version = "1.18.10";
  hash = "sha256-nO3MpYhF3wyUdK4AJ0xEqVyd+u+xMvxZkhwox8EG+OY=";
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
      src = ./tzdata-1.17.patch;
      inherit tzdata;
    })
    ./remove-tools-1.11.patch
    ./go_no_vendor_checks-1.16.patch

    # runtime: support riscv64 SV57 mode
    (fetchpatch {
      url = "https://github.com/golang/go/commit/1e3c19f3fee12e5e2b7802a54908a4d4d03960da.patch";
      hash = "sha256-mk/9gXwQEcAkiRemF6GiNU0c0fhDR29/YcKgQR7ONTA=";
    })
  ];
}
