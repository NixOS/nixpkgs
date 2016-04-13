{ qtSubmodule, lib, copyPathsToStore, python, qtbase, qtsvg, qtxmlpatterns }:

qtSubmodule {
  name = "qtdeclarative";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python ];
  postFixup = ''
    fixQtModuleCMakeConfig "Qml"
    fixQtModuleCMakeConfig "Quick"
    fixQtModuleCMakeConfig "QuickTest"
    fixQtModuleCMakeConfig "QuickWidgets"
  '';
}
