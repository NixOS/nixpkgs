{ lib
, stdenv
, callPackage
, fetchurl
, Foundation
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix { inherit Foundation; };
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix { };
  javaPlatform = {
    "aarch64-linux" = "linux-aarch64";
    "x86_64-linux" = "linux-amd64";
    "aarch64-darwin" = "darwin-aarch64";
    "x86_64-darwin" = "darwin-amd64";
  };
  javaPlatformVersion = javaVersion:
    "${javaVersion}-${javaPlatform.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}")}";
  source = product: javaVersion: (import ./hashes.nix).${product}.${javaPlatformVersion javaVersion};

in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  graalvm11-ce = buildGraalvm rec {
    version = "22.3.1";
    javaVersion = "11";
    src = fetchurl (source "graalvm-ce" javaVersion);
    meta.platforms = builtins.attrNames javaPlatform;
    products = [ native-image-installable-svm-java11 ];
  };

  native-image-installable-svm-java11 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "native-image-installable-svm" javaVersion);
  };

  graalvm17-ce = buildGraalvm rec {
    version = "22.3.1";
    javaVersion = "17";
    src = fetchurl (source "graalvm-ce" javaVersion);
    meta.platforms = builtins.attrNames javaPlatform;
    products = [ native-image-installable-svm-java17 ];
  };

  native-image-installable-svm-java17 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "native-image-installable-svm" javaVersion);
  };
}
