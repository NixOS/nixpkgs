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
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
    hash = "sha256-JWE0eSCAaAJ2vyiKGksYUzS3enCIJYCaT3tVV7fP1BA=";
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
    changelog = "https://github.com/luispedro/jug/blob/v${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ luispedro ];
  };
}
