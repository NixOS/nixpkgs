{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.7.2";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12398831a3a3a2ed7c67e693cf596610c23dd23e0889bfeae0830bbd1d41e5b9";
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
