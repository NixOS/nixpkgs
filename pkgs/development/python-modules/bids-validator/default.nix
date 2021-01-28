{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.10";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae421596b6b69670bd5a4ed3e586c6147e04448704b14b0705fd2bfe03d16b41";
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
