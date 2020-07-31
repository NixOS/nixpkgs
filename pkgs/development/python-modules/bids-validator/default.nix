{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.4";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8292f4efb3617532f93c60acfec242150406bfd9e298d7f01187d67c311aa91";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
