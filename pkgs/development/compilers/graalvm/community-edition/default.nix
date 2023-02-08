{ stdenv, callPackage, fetchurl }:

let
  buildGraalvm = callPackage (import ./buildGraalvm.nix) { };
  sources = javaVersion: builtins.fromJSON (builtins.readFile (./. + "/graalvm${javaVersion}-ce-sources.json"));
in
rec {
  graalvm11-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "11";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
  };

  graalvm17-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "17";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
  };
}
