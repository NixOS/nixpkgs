{ qtSubmodule, lib, copyPathsToStore, python2, qtbase, qtsvg, qtxmlpatterns }:

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
}
