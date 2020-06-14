{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "jsonpickle";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "158x85dp5y61j7bshp1b0fbpzbq0f4jfyab6z3iz92p21awa5g3i";
  };

  checkInputs = [ pytest ];

  checkPhase = "pytest tests/jsonpickle_test.py";

  meta = {
    description = "Python library for serializing any arbitrary object graph into JSON";
    homepage = "http://jsonpickle.github.io/";
    license = lib.licenses.bsd3;
  };

}
