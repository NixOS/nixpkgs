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
  version = "0.5.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-types";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zA/yLUwnmu4hmdWK1OuZ77mTnaM1p8ZEqSl41dN2a+w=";
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
