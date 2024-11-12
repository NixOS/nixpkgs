{ qtModule
, qtbase
, qtwebsockets
}:

qtModule {
  pname = "qthttpserver";
  propagatedBuildInputs = [ qtbase qtwebsockets ];
}
