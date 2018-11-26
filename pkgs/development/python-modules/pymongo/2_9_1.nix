{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nrr1fxyrlxd69bgxl7bvaj2j4z7v3zaciij5sbhxg0vqiz6ny50";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mongodb/mongo-python-driver;
    license = licenses.asl20;
    description = "Python driver for MongoDB ";
  };

}
