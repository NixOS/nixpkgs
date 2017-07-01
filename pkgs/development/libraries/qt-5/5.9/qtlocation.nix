{ qtSubmodule, qtbase, qtmultimedia }:

qtSubmodule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
  # Linking with -lclipper fails with parallel build enabled
  enableParallelBuilding = false;
}
