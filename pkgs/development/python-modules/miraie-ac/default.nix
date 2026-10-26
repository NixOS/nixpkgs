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

buildPythonPackage (finalAttrs: {
  pname = "miraie-ac";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "miraie_ac";
    hash = "sha256-q4CXdJrNr9nhkY74eHllmRchrQx770vQJMqRtggxxlw=";
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
})
