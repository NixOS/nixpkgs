{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.8.4";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63e7a02c9ddb5505a345e178f4e436b82c35ec0a177d7047b67ea10ea3029a68";
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
