{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, packaging

# tests
, pyqt5
, pyside
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "QtPy";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yozUIXF1GGNEKZ7kwPfnrc82LHCFK6NbJVpTQHcCXAY=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'PyQt5.QtConnectivity'
  checkInputs = [
    pyside
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
