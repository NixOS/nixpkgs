{ stdenv, qtSubmodule, makeQtWrapper, copyPathsToStore, python2, qtbase, qtsvg, qtxmlpatterns }:

with stdenv.lib;

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 makeQtWrapper ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';

  postInstall = ''
    wrapQtProgram $out/bin/qmleasing
    wrapQtProgram $out/bin/qmlscene
    wrapQtProgram $out/bin/qmltestrunner
  '' + optionalString (stdenv.isDarwin) ''
    wrapQtProgram $out/bin/qml.app/Contents/MacOS/qml
  '';
}
