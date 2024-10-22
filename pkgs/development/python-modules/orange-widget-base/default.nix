{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pyqt5,
  pyqtwebengine,
  matplotlib,
  orange-canvas-core,
  pyqtgraph,
  typing-extensions,
  qt5,
  pytestCheckHook,
  pytest-qt,
  appnope,
}:

buildPythonPackage rec {
  pname = "orange-widget-base";
  version = "4.24.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2cBg7s4+qMrb2G4sMk5yednOzJCNheHIQ3lty4KAg18=";
  };

  propagatedBuildInputs = [
    matplotlib
    orange-canvas-core
    pyqt5
    pyqtgraph
    pyqtwebengine
    typing-extensions
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ appnope ];

  pythonImportsCheck = [ "orangewidget" ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  nativeCheckInputs = [
    pytest-qt
    pytestCheckHook
  ];

  disabledTestPaths = [
    "orangewidget/report/tests/test_report.py"
    "orangewidget/tests/test_widget.py"
  ];

  meta = {
    description = "Implementation of the base OWBaseWidget class and utilities for use in Orange Canvas workflows";
    homepage = "https://github.com/biolab/orange-widget-base";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
