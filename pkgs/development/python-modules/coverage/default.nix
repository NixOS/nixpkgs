{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a34cb28e0747ea15e82d13e14de606747e9e484fb28d63c999483f5d5188e89b";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "http://nedbatchelder.com/code/coverage/";
    license = lib.licenses.bsd3;
  };
}
