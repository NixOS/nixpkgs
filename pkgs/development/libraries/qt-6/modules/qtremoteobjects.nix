{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtremoteobjects";
  qtInputs = [ qtbase qtdeclarative ];
}
