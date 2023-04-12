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
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BgPJyDzMA1pHF6EpCL9rxssiUJgn6i7A6Uwtp8ntV8U=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  doCheck = false; # ModuleNotFoundError: No module named 'PyQt5.QtConnectivity'
  nativeCheckInputs = [
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
