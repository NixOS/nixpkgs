{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  docker-compose,
  pytest,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pytest-docker";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I3FSSASnUqqnZsebnu6OY0U0r924JZfztXPafF1v+18=";
  };

  postPatch = ''
    sed -i "/addopts =/d" setup.cfg
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ attrs ];

  optional-dependencies = {
    docker-compose-v1 = [ docker-compose ];
  };

  #Bypass the /homeless/shelter error
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # These tests require docker and docker compose to be available in path to create containers
    "tests/test_fixtures.py"
    "tests/test_integration.py"
  ];
  pythonImportsCheck = [ "pytest_docker" ];

  meta = {
    description = "Simple pytest fixtures for Docker and Docker Compose based tests";
    homepage = "https://github.com/avast/pytest-docker";
    changelog = "https://github.com/avast/pytest-docker/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
}
