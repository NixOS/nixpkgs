{ lib, callPackage, fetchgit, gn }:

callPackage ./generic.nix {
  version = "m102";
  rev = "d4442274e967ec96d89345d2afd2d81f09e416ed";  # chrome/m102 branch
  hash = "sha256-h7BNTu2Q3lRhgeBwAZZPtezjlNCzKMvmN7UVh/ON0vM=";
  depSrcs = import ./skia-deps-m102.nix { inherit fetchgit; };
}
