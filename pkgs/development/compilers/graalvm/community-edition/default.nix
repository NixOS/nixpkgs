{ lib
, stdenv
, callPackage
, fetchurl
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix;
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix;
  javaPlatform = {
    "aarch64-linux" = "linux-aarch64";
    "x86_64-linux" = "linux-amd64";
    "aarch64-darwin" = "darwin-aarch64";
    "x86_64-darwin" = "darwin-amd64";
  };
  javaPlatformVersion = javaVersion:
    "${javaVersion}-${javaPlatform.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}")}";
  source = product: javaVersion: (import ./hashes.nix).${product}.${javaPlatformVersion javaVersion}
    or (throw "Unsupported product combination: product=${product} java=${javaVersion} system=${stdenv.system}");

in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  ### Java 11 ###

  # Mostly available for build purposes, not to be exposed at the top level
  graalvm11-ce-bare = buildGraalvm rec {
    version = "22.3.1";
    javaVersion = "11";
    src = fetchurl (source "graalvm-ce" javaVersion);
    meta.platforms = builtins.attrNames javaPlatform;
    products = [ ];
  };

  graalvm11-ce = graalvm11-ce-bare.override {
    products = [ native-image-installable-svm-java11 ];
  };

  # Mostly available for testing, not to be exposed at the top level
  graalvm11-ce-full = graalvm11-ce-bare.override {
    products = [
      js-installable-svm-java11
      llvm-installable-svm-java11
      native-image-installable-svm-java11
      nodejs-installable-svm-java11
      python-installable-svm-java11
      ruby-installable-svm-java11
      wasm-installable-svm-java11
    ];
  };

  js-installable-svm-java11 = callPackage ./js-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "js-installable-svm" javaVersion);
  };

  llvm-installable-svm-java11 = callPackage ./llvm-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "llvm-installable-svm" javaVersion);
  };

  native-image-installable-svm-java11 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "native-image-installable-svm" javaVersion);
  };

  nodejs-installable-svm-java11 = callPackage ./nodejs-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "nodejs-installable-svm" javaVersion);
    graalvm-ce = graalvm11-ce-bare;
  };

  python-installable-svm-java11 = callPackage ./python-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "python-installable-svm" javaVersion);
  };

  ruby-installable-svm-java11 = callPackage ./ruby-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "ruby-installable-svm" javaVersion);
    llvm-installable-svm = llvm-installable-svm-java11;
  };

  wasm-installable-svm-java11 = callPackage ./wasm-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.1";
    src = fetchurl (source "wasm-installable-svm" javaVersion);
  };

  ### Java 17 ###

  # Mostly available for build purposes, not to be exposed at the top level
  graalvm17-ce-bare = buildGraalvm rec {
    version = "22.3.1";
    javaVersion = "17";
    src = fetchurl (source "graalvm-ce" javaVersion);
    meta.platforms = builtins.attrNames javaPlatform;
    products = [ ];
  };

  graalvm17-ce = graalvm17-ce-bare.override {
    products = [ native-image-installable-svm-java17 ];
  };

  # Mostly available for testing, not to be exposed at the top level
  graalvm17-ce-full = graalvm17-ce-bare.override {
    products = [
      js-installable-svm-java17
      llvm-installable-svm-java17
      native-image-installable-svm-java17
      nodejs-installable-svm-java17
      python-installable-svm-java17
      ruby-installable-svm-java17
      wasm-installable-svm-java17
    ];
  };

  js-installable-svm-java17 = callPackage ./js-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "js-installable-svm" javaVersion);
  };

  llvm-installable-svm-java17 = callPackage ./llvm-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "llvm-installable-svm" javaVersion);
  };

  native-image-installable-svm-java17 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "native-image-installable-svm" javaVersion);
  };

  nodejs-installable-svm-java17 = callPackage ./nodejs-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "nodejs-installable-svm" javaVersion);
    graalvm-ce = graalvm17-ce-bare;
  };

  python-installable-svm-java17 = callPackage ./python-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "python-installable-svm" javaVersion);
  };

  ruby-installable-svm-java17 = callPackage ./ruby-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "ruby-installable-svm" javaVersion);
    llvm-installable-svm = llvm-installable-svm-java17;
  };

  wasm-installable-svm-java17 = callPackage ./wasm-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.1";
    src = fetchurl (source "wasm-installable-svm" javaVersion);
  };
}
