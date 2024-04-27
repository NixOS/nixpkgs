{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytestCheckHook,
  pythonOlder,
  requests,
  retrying,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meross-iot";
  version = "0.4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    rev = "refs/tags/${version}";
    hash = "sha256-Zf392XMhSrCn5KM761YXzinD46Et4itva7USsFNRgPI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    paho-mqtt
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
