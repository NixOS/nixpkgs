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

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miraie_ac";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IiRDPz5IcD3Df+vw4YvR3zc0oThGjb7pBJfD4d98h/g=";
  };

 build-system = [ poetry-core ];

  dependencies = [
    aiomqtt
    aiohttp
    certifi
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/rkzofficial/miraie-ac";
    changelog = "https://github.com/rkzofficial/miraie-ac/releases";
    description = "Python library for controlling Panasonic Miraie ACs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ananthb ];
  };
}
