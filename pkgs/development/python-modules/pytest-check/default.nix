{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-7jTNoczFAF3inFP7ztPWXXFLtTbZD1aSdI8fFN+p90U=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
