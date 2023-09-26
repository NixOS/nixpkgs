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
  hashes = product: (import (./. + "/${product}/hashes.nix"));
  version = product: (hashes product).version;
  source = product: (hashes product).${product}.${javaPlatform.${stdenv.system}}
    or (hashes product).${product}.${javaPlatformForProducts.${stdenv.system}}
    or (throw "Unsupported product combination: product=${product} system=${stdenv.system}");
in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  graalvm-ce = buildGraalvm {
    version = version "graalvm-ce";
    src = fetchurl (source "graalvm-ce");
    meta.platforms = builtins.attrNames javaPlatform;
  };

  graaljs = callPackage ./graaljs {
    version = version "graaljs";
    src = fetchurl (source "graaljs");
  };

  graalnodejs = callPackage ./graalnodejs {
    version = "21";
    src = fetchurl (source "graalnodejs");
  };

  graalpy = callPackage ./graalpy {
    version = version "graalpy";
    src = fetchurl (source "graalpy");
  };

  truffleruby = callPackage ./truffleruby {
    version = version "truffleruby";
    src = fetchurl (source "truffleruby");
  };
}
