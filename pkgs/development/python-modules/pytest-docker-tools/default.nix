{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-docker-tools";
  version = "3.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "pytest-docker-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P2aga2Wz6CtXGESHWxyFGJfw3gjMsxwzP1edCHDdsD4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ docker ];

  # Tests require a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "pytest_docker_tools" ];

  meta = {
    description = "Opinionated helpers for creating py.test fixtures for Docker integration and smoke testing environments";
    homepage = "https://github.com/Jc2k/pytest-docker-tools";
    changelog = "https://github.com/Jc2k/pytest-docker-tools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
