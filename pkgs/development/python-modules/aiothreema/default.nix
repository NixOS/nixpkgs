{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pynacl,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiothreema";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LukasQ";
    repo = "aiothreema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JMnw6zQlMXbtCHrCo2CRBZPS7iSCYsguAvWj5dNDrrw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pynacl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiothreema" ];

  meta = {
    description = "Async Python client for the Threema Gateway HTTP API";
    homepage = "https://github.com/LukasQ/aiothreema";
    changelog = "https://github.com/LukasQ/aiothreema/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
