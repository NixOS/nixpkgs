{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pythonOlder,
  pycryptodomex,
  requests,
  retrying,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meross-iot";
  version = "0.4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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
    retrying
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "meross_iot" ];

  meta = with lib; {
    # https://github.com/albertogeniola/MerossIot/pull/413
    broken = lib.versionAtLeast paho-mqtt.version "2";
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    changelog = "https://github.com/albertogeniola/MerossIot/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
