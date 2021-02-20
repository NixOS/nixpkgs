{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db5098587f58fbf8582d9bda2462762b367207246d3e19623782fb449c3c5fcc";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
