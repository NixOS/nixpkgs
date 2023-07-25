{ qtModule
, qtbase
, qtdeclarative
, qtsvg
}:

qtModule {
  pname = "qtsensors";
  qtInputs = [ qtbase qtdeclarative qtsvg ];
}
