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
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "pytest-run-parallel";
    tag = "v${version}";
    hash = "sha256-6cfpPJItOmb79KERqpKz/nQlyTrAj4yv+bGM8SXrsXg=";
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
    description = "Simple pytest plugin to run tests concurrently";
    homepage = "https://github.com/Quansight-Labs/pytest-run-parallel";
    changelog = "https://github.com/Quansight-Labs/pytest-run-parallel/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
