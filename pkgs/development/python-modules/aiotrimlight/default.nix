{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotrimlight";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "spdevpro";
    repo = "trimlight-ha-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zFQVZvFYkFOcvKweeETNa3/Iu0RLcqrDNq5d2GDoips=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiotrimlight" ];

  meta = {
    description = "Asynchronous client for the Trimlight V3 local HTTP API";
    homepage = "https://github.com/spdevpro/trimlight-ha-api";
    changelog = "https://github.com/spdevpro/trimlight-ha-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
