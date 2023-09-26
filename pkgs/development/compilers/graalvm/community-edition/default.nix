{ lib
, stdenv
, callPackage
, fetchurl
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix;
  javaPlatform = {
    "aarch64-linux" = "linux-aarch64";
    "x86_64-linux" = "linux-x64";
    "aarch64-darwin" = "macos-aarch64";
    "x86_64-darwin" = "macos-x64";
  };
  source = product: (import ./hashes.nix).${product}.${javaPlatform.${stdenv.system}}
    or (throw "Unsupported product combination: product=${product} system=${stdenv.system}");
in
rec {
  inherit buildGraalvm;

  graalvm-ce = buildGraalvm {
    version = "21.0.0";
    src = fetchurl (source "graalvm-ce");
    meta.platforms = builtins.attrNames javaPlatform;
  };
}
