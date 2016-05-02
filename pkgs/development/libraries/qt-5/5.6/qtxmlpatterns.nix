{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtxmlpatterns";
  qtInputs = [ qtbase ];
  postFixup = ''
    fixQtModuleCMakeConfig "XmlPatterns"
  '';
}
