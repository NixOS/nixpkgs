{ qtModule
, qtbase
, qtwebsockets
}:

qtModule {
  pname = "qthttpserver";
  qtInputs = [ qtbase qtwebsockets ];
}
