{ qtModule
, qtbase
}:

qtModule {
  pname = "qtshadertools";
  propagatedBuildInputs = [ qtbase ];
}
