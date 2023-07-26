{ lib
, buildPythonPackage
, fetchPypi
, anyqt
, cachecontrol
, commonmark
, dictdiffer
, docutils
, filelock
, lockfile
, pytest-qt
, pytestCheckHook
, python
, qasync
, qt5
, writeShellScript
, xvfb-run
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.1.31";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kqh/c0pEWFLqf1BMD79li1MqLpH/4xrdTH9+/7YO/tg=";
  };

  propagatedBuildInputs = [
    anyqt
    cachecontrol
    commonmark
    dictdiffer
    docutils
    filelock
    lockfile
    qasync
  ];

  pythonImportsCheck = [ "orangecanvas" ];

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
    "orangecanvas/canvas/items/tests/test_graphicstextitem.py"
  ];

  meta = {
    description = "Orange framework for building graphical user interfaces for editing workflows";
    homepage = "https://github.com/biolab/orange-canvas-core";
    license = [ lib.licenses.gpl3 ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
