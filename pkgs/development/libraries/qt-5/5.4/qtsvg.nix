{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
  postFixup = ''
    fixQtModuleCMakeConfig "Svg"
  '';
}
