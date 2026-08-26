{
  lib,
  aiohttp,
  aiortsp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pycryptodomex,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "reolink-aio";
  version = "0.21.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    tag = finalAttrs.version;
    hash = "sha256-YnzP4ArMoyMaaAI90Hz5wEKHcTLY3ER/Ar4u4MJ2gFc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiortsp
    orjson
    pycryptodomex
    typing-extensions
  ];

  pythonImportsCheck = [ "reolink_aio" ];

  # All tests require a network device
  doCheck = false;

  meta = {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
