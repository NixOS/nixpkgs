{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  aiomqtt,
  aiohttp,
  certifi,
}:

buildPythonPackage rec {
  pname = "miraie-ac";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "miraie_ac";
    hash = "sha256-IiRDPz5IcD3Df+vw4YvR3zc0oThGjb7pBJfD4d98h/g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiomqtt
    aiohttp
    certifi
  ];

  pythonRemoveDeps = [ "asyncio" ];

  pythonImportsCheck = [ "miraie_ac" ];

  meta = {
    homepage = "https://github.com/rkzofficial/miraie-ac";
    changelog = "https://github.com/rkzofficial/miraie-ac/releases";
    description = "Python library for controlling Panasonic Miraie ACs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ananthb ];
  };
}
