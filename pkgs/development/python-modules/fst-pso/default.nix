{ lib
, buildPythonPackage
, fetchPypi
, miniful
, numpy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fst-pso";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s9FuwnsLTTazWzBq9AwAzQs05eCp4wpx7QJJDolUomo=";
  };

  propagatedBuildInputs = [
    miniful
    numpy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "fstpso"
  ];

  meta = with lib; {
    description = "Fuzzy Self-Tuning PSO global optimization library";
    homepage = "https://github.com/aresio/fst-pso";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
