{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "Velisarios";
  owner = "vrahli";
  inherit version;
  defaultVersion = if lib.versions.range "8.6" "8.8" coq.coq-version then "20180221" else null;

  release."20180221".rev = "e1eee1f10d5d46331a560bd8565ac101229d0d6b";
  release."20180221".sha256 = "0l9885nxy0n955fj1gnijlxl55lyxiv9yjfmz8hmfrn9hl8vv1m2";
  mlPlugin = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  preBuild = "./create-makefile.sh";
  installPhase = ''
    mkdir -p $out/lib/coq/${coq.coq-version}/Velisarios
    cp -pR model/*.vo $out/lib/coq/${coq.coq-version}/Velisarios
  '';
}
