{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "076a7f2f7c251635cf6116ac8e45eefac77758ee5a77ab7bd2f63999e957613b";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
