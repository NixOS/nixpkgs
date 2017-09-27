{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
