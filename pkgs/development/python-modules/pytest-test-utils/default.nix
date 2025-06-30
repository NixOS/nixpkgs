{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Pytest utilities for tests";
    homepage = "https://github.com/iterative/pytest-test-utils";
    changelog = "https://github.com/iterative/pytest-test-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
