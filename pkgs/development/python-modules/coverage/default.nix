{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38f16b1317b8dd82df67ed5daa5f5e7c959e46579840d77a67a4ceb9cef0a50b";
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
