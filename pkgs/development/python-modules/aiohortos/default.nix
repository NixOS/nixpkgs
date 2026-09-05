{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohortos";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "wildekek";
    repo = "aiohortos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8CBD9hncGHitGOThZATxsH7Z45EQ6taGFPq4cRwcK/8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohortos" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Async client for the Ridder HortOS Automation API";
    homepage = "https://github.com/wildekek/aiohortos";
    changelog = "https://github.com/wildekek/aiohortos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
