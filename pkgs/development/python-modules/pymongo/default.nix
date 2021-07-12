{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "539d4cb1b16b57026999c53e5aab857fe706e70ae5310cc8c232479923f932e6";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
