{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "993257f6ca3cde55332af1f62af3e04ca89ce63c08b56a387cdd46136c72f2fa";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
