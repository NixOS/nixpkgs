{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtcharts";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
  passthru = {
    propagateEnv = {
      QT_PLUGIN_PATH = "%bin%/${qtbase.qtPluginPrefix}";
      QML2_PLUGIN_PATH = "%bin%/${qtbase.qtQmlPrefix}";
    };
  };
}
