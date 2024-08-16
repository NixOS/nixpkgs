{
  aiohttp,
  async-timeout,
  async-upnp-client,
  buildPythonPackage,
  fetchPypi,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-linkplay";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    pname = "python_linkplay";
    inherit version;
    hash = "sha256-mChlhJt2p77KWXWNZztrEA8Z2BmYkPLYPdv9Gw7p5/I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    async-upnp-client
  ];

  pythonImportsCheck = [ "linkplay" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # no tests on PyPI, no tags on GitHub
  # https://github.com/Velleman/python-linkplay/issues/23
  doCheck = false;

  meta = {
    description = "Python Library for Seamless LinkPlay Device Control";
    homepage = "https://github.com/Velleman/python-linkplay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
