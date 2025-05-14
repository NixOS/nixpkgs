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
  version = "2.5.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-I1fX33fDldMMDElXck/fzhp16ovJ6yMIwP/lb2KscMo=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
