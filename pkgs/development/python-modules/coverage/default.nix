{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56e448f051a201c5ebbaa86a5efd0ca90d327204d8b059ab25ad0f35fbfd79f1";
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