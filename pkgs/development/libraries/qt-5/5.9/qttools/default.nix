{ stdenv, qtSubmodule, copyPathsToStore, qtbase }:

with stdenv.lib;

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  outputs = [ "bin" "dev" "out" ];
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  # qmake moves all binaries to $dev in preFixup
  postFixup = ''
    moveToOutput "bin/qdbus" "$bin"
    moveToOutput "bin/qdbusviewer" "$bin"
    moveToOutput "bin/qtpaths" "$bin"
  '';
}
