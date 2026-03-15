{
  aiohomematic,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomematic-config";
  version = "2026.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sukramj";
    repo = "aiohomematic-config";
    tag = finalAttrs.version;
    hash = "sha256-lIvyFS/m1TwAj8und8EoX2E9ngM4rUw9BkfpETuwUGc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohomematic
    pydantic
  ];

  pythonImportsCheck = [ "aiohomematic_config" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/sukramj/aiohomematic-config/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Presentation-layer library for Homematic device configuration UI";
    homepage = "https://github.com/sukramj/aiohomematic-config";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
