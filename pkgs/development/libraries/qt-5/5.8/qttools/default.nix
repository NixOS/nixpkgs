{ stdenv, qtSubmodule, copyPathsToStore, qtbase }:

with stdenv.lib;

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];

  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  postFixup = ''
    moveToOutput "bin/qdbus" "$out"
    moveToOutput "bin/qtpaths" "$out"
  '';
}
