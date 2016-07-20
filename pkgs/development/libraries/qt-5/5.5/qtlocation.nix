{ qtSubmodule, qtbase, qtmultimedia }:

qtSubmodule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  postFixup = ''
    fixQtModuleCMakeConfig "Positioning"
  '';
}
