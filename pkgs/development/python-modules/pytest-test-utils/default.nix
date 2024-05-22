{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-19oNAFff++7ntMdlnMXYc2w5I+EzGwWJh+rB1IjNZGk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_test_utils" ];

  meta = with lib; {
    description = "Pytest utilities for tests";
    homepage = "https://github.com/iterative/pytest-test-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
