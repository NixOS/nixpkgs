{ qtSubmodule, python, qtbase, qtsvg, qtxmlpatterns }:

qtSubmodule {
  name = "qtdeclarative";
  patches = [ ./0001-nix-profiles-import-paths.patch ];
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python ];
  postFixup = ''
    fixQtModuleCMakeConfig "Qml"
    fixQtModuleCMakeConfig "Quick"
    fixQtModuleCMakeConfig "QuickTest"
    fixQtModuleCMakeConfig "QuickWidgets"
  '';
}
