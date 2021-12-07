{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.8.8";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9ebc4cf1004bd343bbb56105b1eb2be833200e466dbaff7dfd267fca044d55e";
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
