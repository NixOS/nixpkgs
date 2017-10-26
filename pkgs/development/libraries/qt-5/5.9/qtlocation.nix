{ qtSubmodule, qtbase, qtmultimedia }:

qtSubmodule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
  # Linking with -lclipper fails with parallel build enabled
  enableParallelBuilding = false;
}
