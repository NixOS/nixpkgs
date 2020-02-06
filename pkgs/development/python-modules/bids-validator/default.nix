{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.3.12";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a244b09adfd083292ed1f7ff335676a1e2effbbffe62b02a4abaf377d33ef86";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
