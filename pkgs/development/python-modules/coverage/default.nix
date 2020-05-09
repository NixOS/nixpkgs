{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ll0hr8g3szbxa4al6khhzi6l92a3vwyldj0085whl44s55gq2zr";
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
