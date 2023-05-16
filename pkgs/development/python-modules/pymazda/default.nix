{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
<<<<<<< HEAD
  version = "0.3.11";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DiXLY4mfgRbE0Y1tOJnkMSQQj1vcySLVDBthOWe7/dM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

=======
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CBPBmzghuc+kvBt50qmU+jHyUdGgLgNX3jcVm9CC7/Q=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aiohttp
    cryptography
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pymazda"
  ];

  meta = with lib; {
    description = "Python client for interacting with the MyMazda API";
    homepage = "https://github.com/bdr99/pymazda";
<<<<<<< HEAD
    changelog = "https://github.com/bdr99/pymazda/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
