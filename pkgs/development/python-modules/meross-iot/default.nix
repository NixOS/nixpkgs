{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pycryptodomex,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "meross-iot";
  version = "0.4.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    tag = finalAttrs.version;
    hash = "sha256-9y8/q218hD7BZIbjJvzwmc9bEzWZI+OrA8ERW36ya3w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    paho-mqtt
    pycryptodomex
    requests
  ]
  ++ aiohttp.optional-dependencies.speedups;

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "meross_iot" ];

  meta = {
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    changelog = "https://github.com/albertogeniola/MerossIot/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
