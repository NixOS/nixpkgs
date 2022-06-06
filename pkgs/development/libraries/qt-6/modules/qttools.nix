{ qtModule
, stdenv
, lib
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qttools";
  qtInputs = [ qtbase qtdeclarative ];
}
