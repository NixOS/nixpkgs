{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest-mypy,
  pytest-pycodestyle,
  pytest-pylint,
  pytest,
  pytestCheckHook,
  requests,
  setuptools,
  types-requests,
  types-setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pytest-docker";
  version = "3.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avast";
    repo = "pytest-docker";
    tag = "v${version}";
    hash = "sha256-LV4v4vyfXwFHOYJdS3kPyPbFWpwXfx1rKZQfFQ0pdQ4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ attrs ];

  nativeCheckInputs = [
    py
    pytest-mypy
    pytest-pycodestyle
    pytest-pylint
    pytestCheckHook
    requests
    types-requests
    types-setuptools
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pytest_docker" ];

  disabledTests = [
    # Tests wants to run docker
    "test_containers_and_volumes_get_cleaned_up"
    "test_main_fixtures_work"
  ];

  meta = {
    description = "Docker-based integration tests";
    homepage = "https://github.com/avast/pytest-docker";
    changelog = "https://github.com/avast/pytest-docker/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
