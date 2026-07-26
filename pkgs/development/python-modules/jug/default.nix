{
  lib,
  bottle,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pyyaml,
  redis,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jug";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "jug";
    tag = "v${version}";
    hash = "sha256-YjBhA+yEdMQ/4yYf25kkXwbvw+ta9Nb4CX8Rnr0du6k=";
  };

  build-system = [ setuptools ];

  dependenciesk = [ bottle ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pyyaml
    redis
  ];

  pythonImportsCheck = [ "jug" ];

  meta = {
    description = "Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
    changelog = "https://github.com/luispedro/jug/blob/v${version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luispedro ];
  };
}
