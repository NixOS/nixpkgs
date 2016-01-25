{ qtSubmodule, qtscript, qtsvg, qtwebkit, qtxmlpatterns }:

qtSubmodule {
  name = "qtquick1";
  patches = [ ./0001-nix-profiles-import-paths.patch ];
  qtInputs = [ qtscript qtsvg qtwebkit qtxmlpatterns ];
  postFixup = ''
    fixQtModuleCMakeConfig "Declarative"
  '';
}
