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
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
    hash = "sha256-Y2TWqJi7GjmWUFpe1b150NgwRw9VKhCk5EoN5NDcPXU=";
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
