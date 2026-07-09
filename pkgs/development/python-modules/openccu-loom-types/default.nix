{
  buildPythonPackage,
  datamodel-code-generator,
  fetchFromGitHub,
  lib,
  pydantic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-loom-types";
  version = "0.1.52";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-types";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cdQvGvOc8RZJ5riWHeRkY07RWu6z9kDYCVSC3+tWPPA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
  ];

  pythonImportsCheck = [ "openccu_loom_types" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/SukramJ/openccu-loom-types/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Generated Pydantic / enum types for the openccu-loom REST + WebSocket contract";
    homepage = "https://github.com/SukramJ/openccu-loom-types";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
