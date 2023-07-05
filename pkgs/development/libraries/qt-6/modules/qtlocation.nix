{ qtModule
, qtbase
, qtdeclarative
, qtpositioning
}:

qtModule {
  pname = "qtlocation";
  qtInputs = [ qtbase qtdeclarative qtpositioning ];
}
