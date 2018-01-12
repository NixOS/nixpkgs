{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.6.0";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6de26d1e171cdc449745b82f1addbc873d105b8e7335097da991c0fc664a4a8";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };
}
