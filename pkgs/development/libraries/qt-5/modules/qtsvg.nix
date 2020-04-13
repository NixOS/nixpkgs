{ qtModule, qtbase }:

qtModule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  passthru = {
    propagateEnv = {
      QT_PLUGIN_PATH = "@bin@/${qtbase.qtPluginPrefix}";
      # QML2_IMPORT_PATH = "@bin@/${qtbase.qtQmlPrefix}";
    };
  };
}
