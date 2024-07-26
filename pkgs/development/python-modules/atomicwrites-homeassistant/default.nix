{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

let
  pname = "atomicwrites-homeassistant";
  version = "1.4.1";
in

buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JWpnIQbxZ0VEUijZZiQLd7VfRqCW0gMFkBpXql0fTC8=";
  };

  pythonImportsCheck = [
    "atomicwrites"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Atomic file writes";
    homepage = "https://pypi.org/project/atomicwrites-homeassistant/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
