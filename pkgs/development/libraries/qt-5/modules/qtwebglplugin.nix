{ qtModule, qtbase, qtwebsockets }:

qtModule {
  pname = "qtwebglplugin";
  qtInputs = [ qtbase qtwebsockets ];
}
