{
  lib,
  stdenv,
  fetchurl,
  graalvmPackages,
  useMusl ? false,
  version ? "22",
}:

graalvmPackages.buildGraalvm {
  inherit useMusl version;
  src = fetchurl (import ./hashes.nix).${version}.hashes.${stdenv.system};
  meta.platforms = builtins.attrNames (import ./hashes.nix).${version}.hashes;
  meta.license = lib.licenses.unfree;
  pname = "graalvm-oracle";
}
