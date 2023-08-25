{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bids-validator";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X569N5zfbTg+mDwQU5iGv16kiOTr8rwhKTEl9RCJMRY=";
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
