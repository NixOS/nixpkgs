{ qtModule, qtbase }:

qtModule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
}
