{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
