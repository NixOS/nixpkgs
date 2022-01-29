{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtquicktimeline";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}
