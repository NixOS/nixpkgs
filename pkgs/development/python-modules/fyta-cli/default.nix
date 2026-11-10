{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "fyta-cli";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "fyta_cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+gPPECRMhhx7H+K3//PRH3ALyY2k6eQ/o9qAVHyyoes=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  doCheck = false; # Failed: async def functions are not natively supported.

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "fyta_cli" ];

  pytestFlags = [ "--snapshot-update" ];

  meta = {
    description = "Module to access the FYTA API";
    homepage = "https://github.com/dontinelli/fyta_cli";
    changelog = "https://github.com/dontinelli/fyta_cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
