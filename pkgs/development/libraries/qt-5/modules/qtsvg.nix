{ qtModule, qtbase }:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
}
