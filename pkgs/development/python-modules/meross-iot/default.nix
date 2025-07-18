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

buildPythonPackage rec {
  pname = "meross-iot";
  version = "0.4.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    tag = version;
    hash = "sha256-EBsWEsP7SzhDbMayD2903T5Q2WDJKboVtyYY4xP8AOE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    paho-mqtt
    pycryptodomex
    requests
  ] ++ aiohttp.optional-dependencies.speedups;

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "meross_iot" ];

  meta = with lib; {
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    changelog = "https://github.com/albertogeniola/MerossIot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
