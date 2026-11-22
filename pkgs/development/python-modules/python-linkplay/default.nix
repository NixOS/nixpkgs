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
  version = "0.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "velbus";
    repo = "python-linkplay";
    tag = "v${version}";
    hash = "sha256-UGYvaprqwEDxLQZUqyl0NXaDvwx1pDRoTjpRRS1KJPc=";
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
    changelog = "https://github.com/velbus/python-linkplay/releases/tag/${src.tag}";
    description = "Python Library for Seamless LinkPlay Device Control";
    homepage = "https://github.com/velbus/python-linkplay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
