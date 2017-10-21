{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "4.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a9c44400ee0f3b4546066e0710e1250fd75831adc02ab99dda176ad8726f424";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = http://nedbatchelder.com/code/coverage/;
    license = lib.licenses.bsd3;
  };
}