{ stdenv, qtSubmodule, copyPathsToStore, qtbase }:

with stdenv.lib;

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  postInstall = ''
    moveToOutput "bin/qdbus" "$bin"
    moveToOutput "bin/qtpaths" "$bin"
  '';
}
