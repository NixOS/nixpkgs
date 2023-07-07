{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtdatavis3d";
  qtInputs = [ qtbase qtdeclarative ];
}
