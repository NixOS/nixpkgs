{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  cffi,
  filelock,
  importlib-metadata,
  pytest,
  rich,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
  semver,
}:

buildPythonPackage rec {
  pname = "pytest-codspeed";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "pytest-codspeed";
    rev = "v${version}";
    hash = "sha256-06U7S0hRb0J4hO48DaKMQk8Uzl2rUi1thQ4lGorfqpU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cffi
    filelock
    importlib-metadata
    pytest
    rich
    setuptools
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    semver
  ];

  pythonImportsCheck = [
    "pytest_codspeed"
  ];

  meta = {
    changelog = "https://github.com/CodSpeedHQ/pytest-codspeed/releases/tag/v${version}";
    description = "Pytest plugin to create CodSpeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/pytest-codspeed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
