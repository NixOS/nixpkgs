{ substituteAll
, callPackage
}:
let
  sigtool = callPackage ./sigtool.nix {};

in substituteAll {
  src = ./sign-apphost.proj;
  codesign = "${sigtool}/bin/codesign";
}
