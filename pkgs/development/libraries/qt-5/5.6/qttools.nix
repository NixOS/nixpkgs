{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase qtdeclarative ];
  postFixup = ''
    moveToOutput "bin/qdbus" "$out"
    moveToOutput "bin/qtpaths" "$out"

    fixQtModuleCMakeConfig "Designer"
    fixQtModuleCMakeConfig "Help"
    fixQtModuleCMakeConfig "LinguistTools"
    fixQtModuleCMakeConfig "UiPlugin"
    fixQtModuleCMakeConfig "UiTools"
  '';
}
