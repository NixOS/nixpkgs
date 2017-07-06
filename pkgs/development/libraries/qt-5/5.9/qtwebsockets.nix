{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
