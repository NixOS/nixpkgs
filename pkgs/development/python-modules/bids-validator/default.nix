{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.9.4";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S/B9N18jGirS9FC+6z72xU+TGU/Zk6pRV9V6j7pI7VA=";
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
