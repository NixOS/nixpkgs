{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "pytest-test-utils";
    tag = version;
    hash = "sha256-19oNAFff++7ntMdlnMXYc2w5I+EzGwWJh+rB1IjNZGk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_test_utils" ];

  meta = {
    description = "Pytest utilities for tests";
    homepage = "https://github.com/iterative/pytest-test-utils";
    changelog = "https://github.com/iterative/pytest-test-utils/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
