{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.8.2";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7969d55e9ed07f6cf7dfd72ed696a05abe56a2f35e81a1ef677f3694b2adf606";
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
