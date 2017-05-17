{ stdenv, qtSubmodule, copyPathsToStore, python2, qtbase, qtsvg, qtxmlpatterns }:

with stdenv.lib;

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
}
