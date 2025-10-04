{ qtModule, qtbase }:

qtModule {
  pname = "qtsvg";
  buildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
