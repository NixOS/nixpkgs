{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "4.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e07d9f1a23e9e93ab5c62902833bf3e4b1f65502927379148b6622686223125c";
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