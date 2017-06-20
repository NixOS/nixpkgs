{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}

