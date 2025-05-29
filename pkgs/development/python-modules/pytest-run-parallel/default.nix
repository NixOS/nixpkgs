{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pytest,

  # optional-dependencies
  psutil,

  # tests
  pytest-cov-stub,
  pytest-order,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-run-parallel";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "pytest-run-parallel";
    tag = "v${version}";
    hash = "sha256-YBky+aoMO3dclod6RTQZF0X8fE8CAgHHY4es8vWHb3U=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytest ];

  optional-dependencies = {
    psutil = [
      psutil
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-order
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_run_parallel"
  ];

  meta = {
    description = "A simple pytest plugin to run tests concurrently";
    homepage = "https://github.com/Quansight-Labs/pytest-run-parallel";
    changelog = "https://github.com/Quansight-Labs/pytest-run-parallel/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
