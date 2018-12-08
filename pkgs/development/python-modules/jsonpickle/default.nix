{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d43ede55b3d9b5524a8e11566ea0b11c9c8109116ef6a509a1b619d2041e7397";
  };

  doCheck = false;

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = http://jsonpickle.github.io/;
    license = lib.licenses.bsd3;
  };

}