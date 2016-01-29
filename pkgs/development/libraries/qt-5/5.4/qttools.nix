{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
  postFixup = ''
    fixQtModuleCMakeConfig "Designer"
    fixQtModuleCMakeConfig "Help"
    fixQtModuleCMakeConfig "LinguistTools"
    fixQtModuleCMakeConfig "UiPlugin"
    fixQtModuleCMakeConfig "UiTools"
  '';
}
