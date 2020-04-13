{ qtModule, qtbase, qtquickcontrols, wayland, pkgconfig }:

qtModule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "out" "dev" "bin" ];
  passthru = {
    propagateEnv = {
      QT_PLUGIN_PATH = "@bin@/${qtbase.qtPluginPrefix}";
      QML2_IMPORT_PATH = "@bin@/${qtbase.qtQmlPrefix}";
    };
  };
}
