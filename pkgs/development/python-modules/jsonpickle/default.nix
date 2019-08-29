{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16xj4r31pnd90slax5mmd5wps5s73wp9mn6sy9nhkl5ih7bj5sfk";
  };

  checkInputs = [ pytest ];

  checkPhase = "pytest tests/jsonpickle_test.py";

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = http://jsonpickle.github.io/;
    license = lib.licenses.bsd3;
  };

}
