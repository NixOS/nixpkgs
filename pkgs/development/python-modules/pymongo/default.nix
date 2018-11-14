{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.7.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f14fb6c4058772a0d74d82874d3b89d7264d89b4ed7fa0413ea0ef8112b268b9";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mongodb/mongo-python-driver;
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };
}
