{ stdenv, qtSubmodule, qtbase, qtdeclarative }:

with stdenv.lib;

qtSubmodule {
  name = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
