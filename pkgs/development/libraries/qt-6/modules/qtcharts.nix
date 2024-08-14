{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtcharts";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
}
