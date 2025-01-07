{
  stdenv,
  fetchurl,
  graalvmCEPackages,
  useMusl ? false,
}:

graalvmCEPackages.buildGraalvm {
  inherit useMusl;
  src = fetchurl (import ./hashes.nix).hashes.${stdenv.system};
  version = (import ./hashes.nix).version;
  meta.platforms = builtins.attrNames (import ./hashes.nix).hashes;
}
