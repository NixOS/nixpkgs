{
  lib,
  antlr4,
  antlr4-python3-runtime,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jre_minimal,
  pydevd,
  typing-extensions,
  pytest-mock,
  pytest7CheckHook,
  pythonAtLeast,
  pyyaml,
  replaceVars,
}:

buildPythonPackage (finalAttrs: {
  pname = "omegaconf";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hydra-ecosystem";
    repo = "omegaconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6wZ3liuMXkWPRbwDwhoO7dW1GicHQib6ogw8fAos9uM=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    jre_minimal
  ];

  dependencies = [
    typing-extensions
    antlr4-python3-runtime
    pyyaml
  ];

  nativeCheckInputs = [
    attrs
    pydevd
    pytest-mock
    pytest7CheckHook
  ];

  pythonImportsCheck = [ "omegaconf" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::UserWarning"
  ];

  disabledTests = [
    # assert (1560791320562868035 == 1560791320562868035) == False
    "test_eq"
    #tests use bash scripting
    "test_docusaurus_standard"
    "test_dependency_audit_workflow"

  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # pathlib._local.Path != pathlib.Path type check mismatch
    "test_errors"
    "test_to_yaml"
    "test_type_str"
  ];

  meta = {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/hydra-ecosystem/omegaconf";
    changelog = "https://github.com/hydra-ecosystem/omegaconf/blob/${finalAttrs.src.tag}/NEWS.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
