{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
  setuptools_80,
  wrapt,
  pytestCheckHook,
  sphinxHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deprecated";
  version = "1.3.1";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tantale";
    repo = "deprecated";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1mB9aRZOsaW7Mqcu1SWIYTusQ7MlMvUucdTyfu++Nx8=";
  };

  build-system = [ setuptools_80 ];

  nativeBuildInputs = [ sphinxHook ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # assertion text mismatch
    "test_classic_deprecated_class_method__warns"
    "test_sphinx_deprecated_class_method__warns"
  ];

  pythonImportsCheck = [ "deprecated" ];

  meta = {
    changelog = "https://github.com/laurent-laporte-pro/deprecated/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tilpner ];
  };
})
