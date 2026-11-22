{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  ty,
  typing-extensions,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "declinate";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ternaris";
    repo = "declinate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GkIg9PcH3VexwFdHLLDiM3yQfV8ryyBMprBNUSAC2L0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ty
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "declinate"
  ];

  meta = {
    description = "Command line interface generator";
    homepage = "https://gitlab.com/ternaris/declinate";
    changelog = "https://gitlab.com/ternaris/declinate/-/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
