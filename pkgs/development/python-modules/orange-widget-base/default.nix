{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyqt5
, pyqtwebengine
, matplotlib
, orange-canvas-core
, pyqtgraph
, typing-extensions
, qt5
, pytestCheckHook
, pytest-qt
, appnope
}:

buildPythonPackage rec {
  pname = "orange-widget-base";
  version = "4.23.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mz+BcZEdg1p9V0ewYRrw3jKBWLMbL9RR6o4hUEUx9DA=";
  };

  propagatedBuildInputs = [
    matplotlib
    orange-canvas-core
    pyqt5
    pyqtgraph
    pyqtwebengine
    typing-extensions
  ] ++ lib.optionals stdenv.isDarwin [
    appnope
  ];

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
