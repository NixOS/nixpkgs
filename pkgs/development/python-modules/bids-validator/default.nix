{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bids-validator";
<<<<<<< HEAD
  version = "1.12.0";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-X569N5zfbTg+mDwQU5iGv16kiOTr8rwhKTEl9RCJMRY=";
=======
    hash = "sha256-QIxWdIt8+Yz3wxgi8zqNicXm59tSVMNFEH6NUnV2/1M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # needs packages which are not available in nixpkgs
  doCheck = false;

  pythonImportsCheck = [
    "bids_validator"
  ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    changelog = "https://github.com/bids-standard/bids-validator/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
