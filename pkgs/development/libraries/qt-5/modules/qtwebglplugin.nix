{ qtModule, qtbase, qtwebsockets }:

qtModule {
  name = "qtwebglplugin";
  qtInputs = [ qtbase qtwebsockets ];
}
