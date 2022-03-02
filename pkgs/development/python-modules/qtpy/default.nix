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
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rf0HP/vS3oHceqoLmDSZ71xZyWrc/cyd6mDULKiF648=";
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
    description = "Abstraction layer for PyQt5/PyQt4/PySide2/PySide";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
