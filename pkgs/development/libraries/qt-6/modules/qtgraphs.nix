{ qtModule
, qtbase
, qtdeclarative
, qtquick3d
, qtquicktimeline
}:

qtModule {
  pname = "qtgraphs";
  qtInputs = [
    qtbase
    qtdeclarative
    qtquick3d
    qtquicktimeline
  ];
}
