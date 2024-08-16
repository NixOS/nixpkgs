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
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Velleman";
    repo = "python-linkplay";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ju4fubZPOVreu7YGhAPfSepXzaXDa7ZpvsAxoSHWLqo=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "aiofiles" ];

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
    changelog = "https://github.com/Velleman/python-linkplay/releases/tag/v${version}";
    description = "Python Library for Seamless LinkPlay Device Control";
    homepage = "https://github.com/Velleman/python-linkplay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
