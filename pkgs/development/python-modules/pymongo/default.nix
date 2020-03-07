{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c43879fe427ea6aa6e84dae9fbdc5aa14428a4cfe613fe0fee2cc004bf3f307c";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/mongodb/mongo-python-driver;
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
