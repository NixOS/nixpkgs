{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-socketio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaxencoapi";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AXENCO-FR";
    repo = "ha-py-axenco-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rqjDI8e3ZeZHsEk0EBaKlEl3w9blinlc2MsTCAKk85o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    python-socketio
  ]
  ++ python-socketio.optional-dependencies.asyncio_client;

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyaxencoapi" ];

  meta = {
    description = "Async Python client for Axenco MyNeomitis REST/Websocket API";
    homepage = "https://github.com/AXENCO-FR/ha-py-axenco-api";
    changelog = "https://github.com/AXENCO-FR/ha-py-axenco-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
