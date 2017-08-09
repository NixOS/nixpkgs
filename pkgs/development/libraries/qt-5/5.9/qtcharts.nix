{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtcharts";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
