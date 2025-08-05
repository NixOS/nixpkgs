{
  lib,
  bottle,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  redis,
}:

buildPythonPackage rec {
  pname = "jug";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Jug";
    inherit version;
    hash = "sha256-B6We+9bW0dfT5DUsxU212e7ueyRc8GgBVPVnIek8ckU=";
  };

  propagatedBuildInputs = [ bottle ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pyyaml
    redis
  ];

  pythonImportsCheck = [ "jug" ];

  meta = with lib; {
    description = "Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
    changelog = "https://github.com/luispedro/jug/blob/v${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ luispedro ];
  };
}
