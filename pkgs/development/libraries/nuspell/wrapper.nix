{ stdenv, lib, nuspell, makeWrapper, dicts ? [] }:

let
  searchPath = lib.makeSearchPath "share/hunspell" dicts;
in
stdenv.mkDerivation {
  name = (lib.appendToName "with-dicts" nuspell).name;
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper ${nuspell}/bin/nuspell $out/bin/nuspell --prefix DICPATH : ${lib.escapeShellArg searchPath}
  '';
  meta = removeAttrs nuspell.meta ["outputsToInstall"];
}
