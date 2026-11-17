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
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioecosmart";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "ecosmart-nz";
    repo = "aioecosmart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i0n12WQslieCKBdPQxeRPctkSdLMjeJ63yIeRbshhQA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioecosmart" ];

  meta = {
    description = "Async client for the Ecosmart price API";
    homepage = "https://github.com/ecosmart-nz/aioecosmart";
    changelog = "https://github.com/ecosmart-nz/aioecosmart/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
