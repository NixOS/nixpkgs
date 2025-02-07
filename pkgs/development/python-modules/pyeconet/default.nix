{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyeconet";
  version = "0.1.26";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "w1ll1am23";
    repo = "pyeconet";
    tag = "v${version}";
    hash = "sha256-3A37/LHCYkqFjbjP3mtO4kRnWZ8NQiFAS67mT2igvqM=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "paho-mqtt" ];

  dependencies = [
    paho-mqtt
    aiohttp
  ];

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [ "pyeconet" ];

  meta = {
    description = "Python interface to the EcoNet API";
    homepage = "https://github.com/w1ll1am23/pyeconet";
    changelog = "https://github.com/w1ll1am23/pyeconet/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
