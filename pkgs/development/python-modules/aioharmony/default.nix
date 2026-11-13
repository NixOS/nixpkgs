{
  lib,
  aiohttp,
  async-timeout,
  blockbuster,
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
  version = "1.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Harmony-Libs";
    repo = "aioharmony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ry42MfXRII3mSXqpVekTdaUFPmk93rwlOXey8DZMARY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    slixmpp
  ];

  nativeCheckInputs = [
    blockbuster
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
