{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.8";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b8c3b9047d2e00e25746d55f56f62071f0a82dd2de59371a1ee589fe28b2852";
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
