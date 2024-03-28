{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, versioneer
}:

buildPythonPackage rec {
  pname = "bids-validator";
  version = "1.14.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q0pghEFmK5qJ3sWgrxs4jWUm+Ox7LO5sDR8GUJWBr/o=";
  };

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

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
