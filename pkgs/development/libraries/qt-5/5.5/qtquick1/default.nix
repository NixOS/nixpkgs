{ qtSubmodule, lib, copyPathsToStore, qtscript, qtsvg, qtwebkit, qtxmlpatterns }:

qtSubmodule {
  name = "qtquick1";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  qtInputs = [ qtscript qtsvg qtwebkit qtxmlpatterns ];
}
