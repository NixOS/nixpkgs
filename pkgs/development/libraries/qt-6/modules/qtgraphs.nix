{ qtModule
, qtbase
, qtdeclarative
, qtquick3d
, qtquicktimeline
}:

qtModule {
  pname = "qtgraphs";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtquick3d
    qtquicktimeline
  ];
}
