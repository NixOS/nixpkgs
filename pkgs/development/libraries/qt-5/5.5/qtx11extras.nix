{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtx11extras";
  qtInputs = [ qtbase ];
  postFixup = ''
    fixQtModuleCMakeConfig "X11Extras"
  '';
}
