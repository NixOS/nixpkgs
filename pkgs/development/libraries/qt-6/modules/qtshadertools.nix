{ qtModule
, qtbase
}:

qtModule {
  pname = "qtshadertools";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
