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
  pname = "qtpy";
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "QtPy";
    inherit version;
    hash = "sha256-paFf/VGVUKE2G9xW/8B/2lamr3KS8Xx7OV1Ag69jKYc=";
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
    mainProgram = "qtpy";
    homepage = "https://github.com/spyder-ide/qtpy";
    license = licenses.mit;
  };
}
