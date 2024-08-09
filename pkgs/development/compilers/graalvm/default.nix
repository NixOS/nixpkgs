{
  lib,
  stdenv,
  callPackage,
  fetchurl,
}:

let
  cePackages = callPackage ./community-edition { };
in
cePackages
// {

  buildGraalvm = callPackage ./buildGraalvm.nix;

  graalvm-ce = cePackages.graalvm-ce;

  graalvm-oracle = callPackage ./graalvm-oracle { };
  graalvm-oracle_17 = callPackage ./graalvm-oracle { version = "17"; };
}
