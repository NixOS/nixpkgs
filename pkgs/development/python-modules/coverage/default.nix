{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "4.4.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "309d91bd7a35063ec7a0e4d75645488bfab3f0b66373e7722f23da7f5b0f34cc";
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