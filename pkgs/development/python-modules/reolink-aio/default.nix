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

buildPythonPackage rec {
  pname = "reolink-aio";
  version = "0.16.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    tag = version;
    hash = "sha256-IrUu9bWBNWBM4EdzVnz76kjYMOyei+CoStVIzyqWOQw=";
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

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
