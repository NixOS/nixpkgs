{ qtSubmodule, qtdeclarative }:

qtSubmodule {
  name = "qtquickcontrols2";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
