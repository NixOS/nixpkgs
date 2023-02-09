{ lib
, stdenv
, callPackage
, fetchurl
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix { };
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix { };
  sources = javaVersion: builtins.fromJSON (builtins.readFile (./. + "/graalvm${javaVersion}-ce-sources.json"));
in
rec {
  inherit buildGraalvm buildGraalvmProduct;

  graalvm11-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "11";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
    products = [ native-image-installable-svm-java11 ];
  };

  native-image-installable-svm-java11 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "11";
    version = "22.3.0";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"native-image-installable-svm|java${javaVersion}|${version}"};
  };

  graalvm17-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "17";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
    products = [ native-image-installable-svm-java17 ];
  };

  native-image-installable-svm-java17 = callPackage ./native-image-installable-svm.nix rec {
    javaVersion = "17";
    version = "22.3.0";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"native-image-installable-svm|java${javaVersion}|${version}"};
  };
}
