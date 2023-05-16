{ lib
, buildPythonPackage
, cbor2
, fetchFromGitHub
, pycryptodome
, pythonOlder
, setuptools
<<<<<<< HEAD
, solc-select
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "crytic-compile";
<<<<<<< HEAD
  version = "0.3.4";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-CeoACtgvMweDbIvYguK2Ca+iTBFONWcE2b0qUkBbQSU=";
=======
    hash = "sha256-4iTvtu2TmxvLTyWm4PV0+yV1fRLYpJHZNBgjy1MFLjM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cbor2
    pycryptodome
    setuptools
<<<<<<< HEAD
    solc-select
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Test require network access
  doCheck = false;

<<<<<<< HEAD
  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "crytic_compile"
  ];

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${version}";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ arturcygan hellwolf ];
=======
    maintainers = with maintainers; [ SuperSandro2000 arturcygan ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
