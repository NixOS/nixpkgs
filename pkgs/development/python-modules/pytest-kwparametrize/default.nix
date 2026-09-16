{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-kwparametrize";
  version = "0.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "pytest-kwparametrize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-khTe4Qi5e8yIDBwVl+rsME3IE3ig+cDzM5ZN8hX0SUE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_kwparametrize" ];

  meta = {
    changelog = "https://github.com/akaihola/pytest-kwparametrize/releases/tag/v${finalAttrs.version}";
    description = "Alternate syntax for @pytest.mark.parametrize with test cases as dictionaries and default value fallbacks";
    homepage = "https://github.com/akaihola/pytest-kwparametrize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
