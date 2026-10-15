{
  qtModule,
  qtbase,
  qtwebsockets,
}:

qtModule {
  pname = "qtwebglplugin";
  propagatedBuildInputs = [
    qtbase
    qtwebsockets
  ];
}
