{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
  '';
}
