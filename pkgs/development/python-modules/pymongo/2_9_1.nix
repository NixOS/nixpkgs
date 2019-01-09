{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "2.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "912516ac6a355d7624374a38337b8587afe3eb535c0a5456b3bd12df637a6e70";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mongodb/mongo-python-driver;
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };

}
