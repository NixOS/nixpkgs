{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
