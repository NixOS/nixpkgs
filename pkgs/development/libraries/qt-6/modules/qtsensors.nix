{ qtModule
, qtbase
, qtdeclarative
, qtsvg
}:

qtModule {
  pname = "qtsensors";
  propagatedBuildInputs = [ qtbase qtdeclarative qtsvg ];
}
