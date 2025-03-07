{ qtModule, qtbase }:

qtModule {
  pname = "qtsvg";
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
