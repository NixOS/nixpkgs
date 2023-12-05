{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dronecan";
  version = "1.0.25";
  format = "setuptools";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0WKmVZwE6OgBckWWvPcn5BYqXMEt6Mr1P68UMHfRp4I=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dronecan"
  ];

  meta = with lib; {
    description = "Python implementation of the DroneCAN v1 protocol stack";
    longDescription = ''
      DroneCAN is a lightweight protocol designed for reliable communication in aerospace and robotic applications via CAN bus.
    '';
    homepage = "https://dronecan.github.io/";
    license = licenses.mit;
    maintainers = teams.ororatech.members;
  };
}
