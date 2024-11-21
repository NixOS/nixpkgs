{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "pytest-leaks";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abalkin";
    repo = "pytest-leaks";
    rev = "refs/tags/v${version}";
    hash = "sha256-Oxjal/bkgynFiYubFABwbNJooGx9GwxQwPy5BLI2DEY=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # assert 0
    "test_broken_faucet"
  ];

  pythonImportsCheck = [ "pytest_leaks" ];

  meta = {
    description = "Pytest plugin to trace resource leaks";
    homepage = "https://abalkin.github.io/pytest-leaks";
    changelog = "https://github.com/abalkin/pytest-leaks/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
