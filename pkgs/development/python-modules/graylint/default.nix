{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  darkgraylib,
  pygments,
  pytestCheckHook,
  pytest-kwparametrize,
  mypy,
  pip-requirements-parser,
  gitMinimal,
}:

buildPythonPackage (finalAttrs: {
  pname = "graylint";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "graylint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AAdU0PyZUGb07EvrexDn75RpZ7F7XeWcNf0KYVn0E5o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    darkgraylib
  ];

  optional-dependencies = {
    color = [ pygments ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-kwparametrize
    pip-requirements-parser
    mypy
    gitMinimal
  ];

  pythonImportsCheck = [ "graylint" ];

  meta = {
    changelog = "https://github.com/akaihola/graylint/releases/tag/v${finalAttrs.version}";
    description = "Run linters and show only new errors compared to an older commit";
    homepage = "https://github.com/akaihola/graylint";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "graylint";
  };
})
