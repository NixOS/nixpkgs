{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.6.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7ebcb846962ee40374db2d9014a89bea9c983ae63c1877957c3a0a756974796";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };
}
