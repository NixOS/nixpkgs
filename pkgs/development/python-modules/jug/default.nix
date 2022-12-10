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
  version = "2.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
    hash = "sha256-3uK6mWaLEGPFoPuznU+OcnkjFZ+beDoIw0vOC4l5gRg=";
  };

  propagatedBuildInputs = [
    bottle
  ];

  checkInputs = [
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
