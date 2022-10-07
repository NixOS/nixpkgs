{ qtModule
, qtbase
}:

qtModule {
  pname = "qtlanguageserver";
  qtInputs = [ qtbase ];

  # Doesn't have version set
  dontCheckQtModuleVersion = true;
}
