{ stdenv, qtSubmodule, qtbase, qtdeclarative }:

with stdenv.lib;

qtSubmodule {
  name = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
