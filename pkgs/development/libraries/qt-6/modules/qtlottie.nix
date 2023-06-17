{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtlottie";
  qtInputs = [ qtbase qtdeclarative ];
}
