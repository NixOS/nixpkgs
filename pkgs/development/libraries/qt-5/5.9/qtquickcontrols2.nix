{ qtSubmodule, qtdeclarative }:

qtSubmodule {
  name = "qtquickcontrols2";
  qtInputs = [ qtdeclarative ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
