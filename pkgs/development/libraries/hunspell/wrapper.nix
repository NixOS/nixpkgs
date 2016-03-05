{ stdenv, lib, hunspell, makeWrapper, dicts ? [] }:
with lib;
let
  searchPath = makeSearchPath "share/hunspell" dicts;
in
stdenv.mkDerivation {
  name = (appendToName "with-dicts" hunspell).name;
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper ${hunspell}/bin/hunspell $out/bin/hunspell --prefix DICPATH : ${searchPath}
  '';
  inherit (hunspell) meta;
}