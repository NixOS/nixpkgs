{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}

