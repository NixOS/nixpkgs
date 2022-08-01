{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.9.5";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-izjda65OYnwaPX30JqdCL5fFh5IW5eJeAIrP4l9I3kE=";
  };

  # needs packages which are not available in nixpkgs
  doCheck = false;

  pythonImportsCheck = [ "bids_validator" ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
