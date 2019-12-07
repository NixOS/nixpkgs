{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4249c6ba45587b959292a727532826c5032d59171f923f7f823788f413c2a5a3";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/mongodb/mongo-python-driver;
    license = licenses.asl20;
    description = "Python driver for MongoDB";
  };
}
