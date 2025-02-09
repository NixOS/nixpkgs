{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pyqt5
, pyqt3d
, pyqtchart
, pyqtdatavisualization
, pyqtwebengine
}:

buildPythonPackage rec {
  pname = "PyQt5-stubs";
  version = "5.15.6.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-qt-tools";
    repo = "PyQt5-stubs";
    rev = version;
    hash = "sha256-qWnvlHnFRy8wbZJ28C0pYqAxod623Epe5z5FZufheDc=";
  };
  postPatch = ''
    # pulls in a dependency to mypy, but we don't want to run linters
    rm tests/test_stubs.py
  '' + lib.optionalString (!pyqt5.connectivityEnabled) ''
    rm tests/qflags/test_QtBluetooth_*
    rm tests/qflags/test_QtNfc_*
  '' + lib.optionalString (!pyqt5.locationEnabled) ''
    rm tests/qflags/test_QtLocation_*
    rm tests/qflags/test_QtPositioning_*
  '' + lib.optionalString (!pyqt5.multimediaEnabled) ''
    rm tests/qflags/test_QtMultimedia_*
  '' + lib.optionalString (!pyqt5.serialPortEnabled) ''
    rm tests/qflags/test_QtSerialPort_*
  '' + lib.optionalString (!pyqt5.toolsEnabled) ''
    rm tests/qflags/test_QtDesigner_*
  '';

  pythonImportsCheck = [
    "PyQt5-stubs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyqt5
    pyqt3d
    pyqtchart
    pyqtdatavisualization
    pyqtwebengine
  ];

  meta = with lib; {
    description = "Stubs for PyQt5 ";
    homepage = "https://github.com/python-qt-tools/PyQt5-stubs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _999eagle ];
  };
}
