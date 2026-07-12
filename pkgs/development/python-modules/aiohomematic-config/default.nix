{
  aiohomematic,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  openccu-data,
  pydantic,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomematic-config";
  version = "2026.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sukramj";
    repo = "aiohomematic-config";
    tag = finalAttrs.version;
    hash = "sha256-uBIdBpjkEIPyuNxTEgTVc068K8UIVvdBXvwZ1MYh7rs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohomematic
    openccu-data
    pydantic
  ];

  pythonImportsCheck = [ "aiohomematic_config" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-xdist
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
