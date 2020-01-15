{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.2.4";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mvp1mi1k6yqgyj7rxij8mlwclqlyfzq08s67v0qaycw44l68ifg";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
