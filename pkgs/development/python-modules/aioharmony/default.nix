{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  slixmpp,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioharmony";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Harmony-Libs";
    repo = "aioharmony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4VlYxGd3I6SLZjJUOSZW9hyfSkX04L/8CGBWp7vTj0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    slixmpp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = {
    description = "Python library for interacting with the Logitech Harmony devices";
    homepage = "https://github.com/Harmony-Libs/aioharmony";
    changelog = "https://github.com/Harmony-Libs/aioharmony/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oro ];
    mainProgram = "aioharmony";
  };
})
