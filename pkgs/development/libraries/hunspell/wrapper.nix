{ stdenv, lib, hunspell, makeWrapper, dicts ? [] }:
let
  searchPath = lib.makeSearchPath "share/hunspell" dicts;
in
stdenv.mkDerivation {
  name = (lib.appendToName "with-dicts" hunspell).name;
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper ${hunspell.bin}/bin/hunspell $out/bin/hunspell --prefix DICPATH : ${lib.escapeShellArg searchPath}
  '';
  meta = removeAttrs hunspell.meta ["outputsToInstall"];
}
