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
  version = "0.4.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    tag = version;
    hash = "sha256-VxwOigIyLTeP1P9uyiavsu14zTjuLCZuka+2cLqJDUw=";
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

  meta = with lib; {
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    changelog = "https://github.com/albertogeniola/MerossIot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
