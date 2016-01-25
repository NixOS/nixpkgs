{ qtSubmodule, qtbase, qtmultimedia }:

qtSubmodule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  postFixup = ''
    fixQtModuleCMakeConfig "Location"
    fixQtModuleCMakeConfig "Positioning"
  '';
}
