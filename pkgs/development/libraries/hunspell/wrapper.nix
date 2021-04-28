{ stdenv, lib, hunspell, makeWrapper, dicts ? [] }:
with lib;
let
  searchPath = makeSearchPath "share/hunspell" dicts;
in
stdenv.mkDerivation {
  name = (appendToName "with-dicts" hunspell).name;
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper ${hunspell.bin}/bin/hunspell $out/bin/hunspell --prefix DICPATH : ${searchPath}
  '';
  meta = removeAttrs hunspell.meta ["outputsToInstall"];
}
