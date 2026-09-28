{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyeconet";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "w1ll1am23";
    repo = "pyeconet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I7DSiV9p/+reSFrd3ENWwCbHwl+i3K1WwM+xx1+rftY=";
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
    changelog = "https://github.com/w1ll1am23/pyeconet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
