{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y7DArNZQwP+2IJmdphHpOq5RBcRqCExM6vL3BO1wjB4=";
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
