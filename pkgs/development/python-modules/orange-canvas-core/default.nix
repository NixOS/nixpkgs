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
, numpy
, pytest-qt
, pytestCheckHook
, qasync
, qt5
, requests-cache
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KMEFZkAZkDhuDPpAts+u825p5pFJZbyrsMW/S1AArp4=";
  };

  propagatedBuildInputs = [
    anyqt
    cachecontrol
    commonmark
    dictdiffer
    docutils
    filelock
    lockfile
    numpy
    qasync
    requests-cache
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
