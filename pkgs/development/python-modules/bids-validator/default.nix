{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.8.9";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01fcb5a8fe6de1280cdfd5b37715103ffa0bafb3c739ca7f5ffc41e46549612e";
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
