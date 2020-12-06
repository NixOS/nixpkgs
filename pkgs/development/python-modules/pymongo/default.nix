{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9c1a2538cd120283e7137ac97ce27ebdfcb675730c5055d6332b0043f4e5a55";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
