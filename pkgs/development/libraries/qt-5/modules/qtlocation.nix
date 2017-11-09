{ qtModule, qtbase, qtmultimedia }:

qtModule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  outputs = [ "bin" "out" "dev" ];
  # Linking with -lclipper fails with parallel build enabled
  enableParallelBuilding = false;
}
