{ qtSubmodule, qtbase, qttools }:

qtSubmodule {
  name = "qtscript";
  qtInputs = [ qtbase qttools ];
  patches = [ ./0001-glib-2.32.patch ];
  postFixup = ''
    fixQtModuleCMakeConfig "Script"
  '';
}
