{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtlottie";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
}
