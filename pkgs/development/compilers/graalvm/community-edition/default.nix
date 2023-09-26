{ lib
, stdenv
, callPackage
, fetchurl
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix;
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix;
  hashes = product: (import (./. + "/${product}/hashes.nix"));
  version = product: (hashes product).version;
  platforms = product: builtins.attrNames (hashes product).${product};
  source = product: (hashes product).${product}.${stdenv.system}
    or (throw "Unsupported product combination: product=${product} system=${stdenv.system}");
in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  graalvm-ce = buildGraalvm {
    version = version "graalvm-ce";
    src = fetchurl (source "graalvm-ce");
    meta.platforms = platforms "graalvm-ce";
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
