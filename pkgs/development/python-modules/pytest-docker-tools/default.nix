{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-docker-tools";
  version = "3.1.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Opionated helpers for creating py.test fixtures for Docker integration and smoke testing environments";
    homepage = "https://github.com/Jc2k/pytest-docker-tools";
    changelog = "https://github.com/Jc2k/pytest-docker-tools/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
