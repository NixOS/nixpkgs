{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtquicktimeline";
  qtInputs = [ qtbase qtdeclarative ];
}
