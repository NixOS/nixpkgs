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
  version = "0.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Velleman";
    repo = "python-linkplay";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sj22bbSJoD52WQBWzdFW36WFQcfvPadpd6mv84vN73U=";
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
