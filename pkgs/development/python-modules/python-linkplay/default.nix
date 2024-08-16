{
  aiohttp,
  async-timeout,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-linkplay";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Velleman";
    repo = "python-linkplay";
    rev = "refs/tags/v${version}";
    hash = "sha256-GUpotQLs+xzsMV3i52YtWYm9IoQLyyw8EY9VhG+uT8o=";
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

  meta = {
    description = "Python Library for Seamless LinkPlay Device Control";
    homepage = "https://github.com/Velleman/python-linkplay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
