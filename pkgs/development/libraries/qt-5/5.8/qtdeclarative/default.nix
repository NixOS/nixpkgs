{ stdenv, qtSubmodule, makeQtWrapper, copyPathsToStore, python2, qtbase, qtsvg, qtxmlpatterns }:

with stdenv.lib;

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 makeQtWrapper ];

  postInstall = ''
    wrapQtProgram $out/bin/qmleasing
    wrapQtProgram $out/bin/qmlscene
    wrapQtProgram $out/bin/qmltestrunner
  '' + optionalString (stdenv.isDarwin) ''
    wrapQtProgram $out/bin/qml.app/Contents/MacOS/qml
  '';
}
