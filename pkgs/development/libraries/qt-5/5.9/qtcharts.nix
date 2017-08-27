{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtcharts";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
