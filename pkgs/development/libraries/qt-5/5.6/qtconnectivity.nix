{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  postFixup = ''
    fixQtModuleCMakeConfig "Bluetooth"
    fixQtModuleCMakeConfig "Nfc"
  '';
}
