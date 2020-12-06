{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "280baa8ec489c4f542f8940f9c4c2181f0306a8ee1a54eceba071a449fb870a0";
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
