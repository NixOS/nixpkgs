{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.7";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "624fade609636c64e7829ff072bdf12f93512948a803059b059e5c90df894be2";
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
