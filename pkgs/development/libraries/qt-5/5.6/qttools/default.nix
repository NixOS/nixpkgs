{ qtSubmodule, lib, copyPathsToStore, qtbase }:

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postFixup = ''
    moveToOutput "bin/qdbus" "$out"
    moveToOutput "bin/qdbusviewer" "$out"
    moveToOutput "bin/qtpaths" "$out"
  '';
}
