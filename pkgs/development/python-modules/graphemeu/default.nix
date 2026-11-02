{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "graphemeu";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timendum";
    repo = "grapheme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NheVptk7qP7beUd9iFQExaoj4rO7l4ZgI4aS5H7ZS5M=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "grapheme"
  ];

  meta = {
    description = "Python package for grapheme aware string handling";
    homepage = "https://github.com/timendum/grapheme";
    changelog = "https://github.com/timendum/grapheme/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
