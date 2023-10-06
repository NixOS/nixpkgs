{ stdenv, lib, symlinkJoin, makeWrapper, idris-no-deps, gmp }:

symlinkJoin {
  inherit (idris-no-deps) name src meta;
  paths = [ idris-no-deps ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/idris \
      --run 'export IDRIS_CC=''${IDRIS_CC:-${stdenv.cc}/bin/cc}' \
      --set 'NIX_CC_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt}' 1 \
      --prefix NIX_CFLAGS_COMPILE " " "-I${lib.getDev gmp}/include" \
      --prefix NIX_CFLAGS_LINK " " "-L${lib.getLib gmp}/lib"
  '';
}
