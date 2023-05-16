{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pox";
<<<<<<< HEAD
  version = "0.3.3";
=======
  version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-4c7WbyoMkqWM82Rrx8y4tHc9QIhLdvhe7aBnBHSHFmc=";
=======
    hash = "sha256-6CUiUpdjjW49SUFfjPtlQHpdFeVvL7f+nZueMFDGXuE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
