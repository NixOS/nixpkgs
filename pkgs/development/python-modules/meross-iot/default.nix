{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytestCheckHook,
  pythonOlder,
  pycryptodomex,
  requests,
  retrying,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meross-iot";
  version = "0.4.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    rev = "refs/tags/${version}";
    hash = "sha256-BcWluaNyo6G7OuIV6yXzc7xcBgQlRR9HbjbNnLigZcE=";
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
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    changelog = "https://github.com/albertogeniola/MerossIot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
