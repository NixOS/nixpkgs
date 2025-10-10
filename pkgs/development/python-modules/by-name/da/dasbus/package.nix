{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygobject3,
  dbus,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "dasbus";
  version = "unstable-11-10-2022";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "dasbus";
    rev = "64b6b4d9e37cd7e0cbf4a7bf75faa7cdbd01086d";
    hash = "sha256-TmhhDrfpP+nUErAd7dUb+RtGBRtWwn3bYOoIqa0VRoc=";
  };

  build-system = [ hatchling ];

  dependencies = [ pygobject3 ];

  nativeCheckInputs = [
    dbus
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/dasbus-project/dasbus/issues/128
    "tests/lib_dbus.py"
    "tests/test_dbus.py"
    "tests/test_unix.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/dasbus";
    description = "DBus library in Python3";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ moni ];
  };
}
