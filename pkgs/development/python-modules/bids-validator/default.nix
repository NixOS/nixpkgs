{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.9.8";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/zl5m7IF+S1vLDIvC47/DRwCiPQpGgsY/OYa+k39fz4=";
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
