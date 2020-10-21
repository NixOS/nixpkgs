{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.6";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef9476ded8226c86fe1d6e6b9f380666ada7a0f4ae39bd5afd7eabbbc6979ab7";
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
