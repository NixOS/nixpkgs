{ lib
, bottle
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
}:

buildPythonPackage rec {
  pname = "jug";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
    hash = "sha256-DNJsmWCSzqyNVjsrFDE9tJhMA9oGM7dBr9h/nZfa+Fk=";
  };

  propagatedBuildInputs = [
    bottle
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pyyaml
    redis
  ];

  pythonImportsCheck = [
    "jug"
  ];

  meta = with lib; {
    description = "A Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ luispedro ];
  };
}
