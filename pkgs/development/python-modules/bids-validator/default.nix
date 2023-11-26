{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bids-validator";
  version = "1.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cgXOTmj7oXIhUzLHhvGsFmUCW3Arbf8rHhWPAKLfmJA=";
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
