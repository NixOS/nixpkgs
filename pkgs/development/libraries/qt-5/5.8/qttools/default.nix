{ stdenv, qtSubmodule, makeQtWrapper, copyPathsToStore, qtbase }:

with stdenv.lib;

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  nativeBuildInputs = [ makeQtWrapper ];

  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  postFixup = ''
    moveToOutput "bin/qdbus" "$out"
    moveToOutput "bin/qtpaths" "$out"
  '';

  postInstall =   ''
    wrapQtProgram $out/bin/qcollectiongenerator
    wrapQtProgram $out/bin/qhelpconverter
    wrapQtProgram $out/bin/qhelpgenerator
    wrapQtProgram $out/bin/qtdiag
  '' + optionalString (stdenv.isDarwin) ''
    wrapQtProgram $out/bin/Assistant.app/Contents/MacOS/Assistant
    wrapQtProgram $out/bin/Designer.app/Contents/MacOS/Designer
    wrapQtProgram $out/bin/Linguist.app/Contents/MacOS/Linguist
    wrapQtProgram $out/bin/pixeltool.app/Contents/MacOS/pixeltool
    wrapQtProgram $out/bin/qdbusviewer.app/Contents/MacOS/qdbusviewer
  '';
}
