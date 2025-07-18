{
  lib,
  stdenv,
  fetchurl,
  graalvmPackages,
  onnxruntime,
  useMusl ? false,
  version ? "24",
}:

graalvmPackages.buildGraalvm {
  inherit useMusl version;
  src = fetchurl (import ./hashes.nix).${version}.${stdenv.system};
  meta.platforms = builtins.attrNames (import ./hashes.nix).${version};
  meta.license = lib.licenses.unfree;
  pname = "graalvm-oracle";
}
