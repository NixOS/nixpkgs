{ lib
, stdenv
, callPackage
, fetchurl
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix;
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix;
  # Argh, this is really inconsistent...
  javaPlatform = {
    "aarch64-linux" = "linux-aarch64";
    "x86_64-linux" = "linux-x64";
    "aarch64-darwin" = "macos-aarch64";
    "x86_64-darwin" = "macos-x64";
  };
  javaPlatformForProducts = {
    "aarch64-linux" = "linux-aarch64";
    "x86_64-linux" = "linux-amd64";
    "aarch64-darwin" = "macos-aarch64";
    "x86_64-darwin" = "macos-x64";
  };
  source = product: (import (./. + "/hashes-${product}.nix")).${product}.${javaPlatform.${stdenv.system}}
    or (import (./. + "/hashes-${product}.nix")).${product}.${javaPlatformForProducts.${stdenv.system}}
    or (throw "Unsupported product combination: product=${product} system=${stdenv.system}");
in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  graalvm-ce = buildGraalvm {
    version = "21.0.0";
    src = fetchurl (source "graalvm-ce");
    meta.platforms = builtins.attrNames javaPlatform;
  };

  graalpy = callPackage ./graalpy.nix {
    version = "23.1.0";
    src = fetchurl (source "graalpy");
  };
}
