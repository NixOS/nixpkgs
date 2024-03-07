{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4c7WbyoMkqWM82Rrx8y4tHc9QIhLdvhe7aBnBHSHFmc=";
  };

  # Test sare failing the sandbox
  doCheck = false;

  pythonImportsCheck = [
    "pox"
  ];

  meta = with lib; {
    description = "Utilities for filesystem exploration and automated builds";
    homepage = "https://pox.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
