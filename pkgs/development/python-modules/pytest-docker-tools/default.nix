{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-docker-tools";
  version = "3.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "pytest-docker-tools";
    tag = "v${version}";
    hash = "sha256-WYfgO7Ch1hCj9cE43jgI+2JEwDOzNvuMtkVV3PdMiBs=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ docker ];

  # Tests require a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "pytest_docker_tools" ];

  meta = {
    description = "Opionated helpers for creating py.test fixtures for Docker integration and smoke testing environments";
    homepage = "https://github.com/Jc2k/pytest-docker-tools";
    changelog = "https://github.com/Jc2k/pytest-docker-tools/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
