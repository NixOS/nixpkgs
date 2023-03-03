{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6CUiUpdjjW49SUFfjPtlQHpdFeVvL7f+nZueMFDGXuE=";
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
