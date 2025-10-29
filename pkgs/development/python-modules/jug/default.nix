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
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luispedro";
    repo = "jug";
    tag = "v${version}";
    hash = "sha256-zERCY9JxceBmhJbytfsm/6rDwipqQ1XjzY/2QFsEEEg=";
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

  meta = with lib; {
    description = "Task-Based Parallelization Framework";
    homepage = "https://jug.readthedocs.io/";
    changelog = "https://github.com/luispedro/jug/blob/v${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ luispedro ];
  };
}
