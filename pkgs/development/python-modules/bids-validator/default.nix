{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "bids-validator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f3bd0402d41ee9be03637d74f34a7db279d00cb9c6386b0597cbbac16ee8f4e";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Validator for the Brain Imaging Data Structure";
    homepage = "https://github.com/bids-standard/bids-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
