{
  lib,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  pytestCheckHook,
  pythonOlder,
  ruff,
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    rev = "refs/tags/v${version}";
    hash = "sha256-MAiTNz2Ygk+JOiiT5DGhJ15xITbS+4Gk23YCKJm7OKE=";
  };

  build-system = [
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [
    black
    ruff
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_examples" ];

  meta = {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
