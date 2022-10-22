{ qtModule
, qtbase
}:

qtModule {
  pname = "qtshadertools";
  qtInputs = [ qtbase ];
}
