{
  aiofiles,
  aiohttp,
  appdirs,
  async-timeout,
  async-upnp-client,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-linkplay";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Velleman";
    repo = "python-linkplay";
    tag = "v${version}";
    hash = "sha256-syCqa9xDuAmsq9eh29PACchdLN1bPj/vCCt3a++LqE4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    appdirs
    async-timeout
    async-upnp-client
    deprecated
  ];

  pythonImportsCheck = [ "linkplay" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Velleman/python-linkplay/releases/tag/${src.tag}";
    description = "Python Library for Seamless LinkPlay Device Control";
    homepage = "https://github.com/Velleman/python-linkplay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
