{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, packaging

# tests
, pyqt5
, pyside2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "QtPy";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2y1QgWeqYQZ4FWXI2lxvFIfeusujNRnO3DX6iZfUJNQ=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'PyQt5.QtConnectivity'
  nativeCheckInputs = [
    pyside2
    (pyqt5.override {
      withConnectivity = true;
      withMultimedia = true;
      withWebKit = true;
      withWebSockets = true;
    })
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Fatal error in python on x86_64
    "qtpy/tests/test_uic.py"
  ];

  meta = with lib; {
    description = "Abstraction layer for PyQt5/PyQt6/PySide2/PySide6";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
