{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  pytest,
  ruff,

  # tests
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pytest-ruff";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "businho";
    repo = "pytest-ruff";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ol+W5mDGMCwptuBa0b+Plkm64UUBf9bmr9YBo8g93Ok=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    pytest
    ruff
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "pytest_ruff" ];

  meta = {
    description = "A pytest plugin to run ruff";
    homepage = "https://github.com/businho/pytest-ruff";
    changelog = "https://github.com/businho/pytest-ruff/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
