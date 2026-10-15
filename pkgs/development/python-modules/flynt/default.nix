{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  hatch-vcs,
}:

buildPythonPackage (finalAttrs: {
  pname = "flynt";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikamensh";
    repo = "flynt";
    tag = finalAttrs.version;
    hash = "sha256-SkkCA4fEHplt9HkEn+QOq4k9lW5qJeZzLZEbNEtKBSo=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flynt" ];

  disabledTests = [
    # AssertionError
    "test_fstringify"
    "test_mixed_quote_types_unsafe"
  ];

  meta = {
    description = "Tool to automatically convert old string literal formatting to f-strings";
    homepage = "https://github.com/ikamensh/flynt";
    changelog = "https://github.com/ikamensh/flynt/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "flynt";
  };
})
