{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
  '';
}
