{ qtSubmodule, lib, copyPathsToStore, python2, qtbase, qtsvg, qtxmlpatterns }:

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 ];
}
