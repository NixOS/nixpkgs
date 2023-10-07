{ callPackage }:

let
  cePackages = callPackage ./community-edition { };
in
cePackages
// rec {
  buildGraalvm = callPackage ./buildGraalvm.nix;

  graalvm-oracle_22 = callPackage ./graalvm-oracle { version = "22"; };
  graalvm-oracle_17 = callPackage ./graalvm-oracle { version = "17"; };
  graalvm-oracle = graalvm-oracle_22;
}
