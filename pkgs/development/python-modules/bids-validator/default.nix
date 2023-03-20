{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.10.0";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WJb9EENkYFVgKuByHFJhed/Slt6ayG31LeQk1+14/Ys=";
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
