{ qtModule
, qtbase
}:

qtModule {
  pname = "qtlanguageserver";
  qtInputs = [ qtbase ];
}
