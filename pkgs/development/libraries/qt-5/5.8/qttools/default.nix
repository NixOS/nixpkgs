{ stdenv, qtSubmodule, copyPathsToStore, qtbase }:

with stdenv.lib;

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  # qmake moves all binaries to $dev in preFixup
  postFixup = ''
    moveToOutput "bin/qdbus" "$bin"
    moveToOutput "bin/qtpaths" "$bin"
  '';
}
