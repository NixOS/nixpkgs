{ qtSubmodule, qtdeclarative }:

qtSubmodule {
  name = "qtenginio";
  qtInputs = [ qtdeclarative ];
  postFixup = ''
    fixQtModuleCMakeConfig "Enginio"
  '';
}
