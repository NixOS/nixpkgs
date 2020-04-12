{ qtModule, qtdeclarative }:

qtModule {
  name = "qtquickcontrols2";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  passthru = {
    propagateEnv = {
      # QT_PLUGIN_PATH = "%bin%/${qtbase.qtPluginPrefix}";
      QML2_PLUGIN_PATH = "%bin%/${qtbase.qtQmlPrefix}";
    };
  };
}
