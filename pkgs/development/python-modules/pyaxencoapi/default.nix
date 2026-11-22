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
  version = "1.0.7.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AXENCO-FR";
    repo = "ha-py-axenco-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-br3HR7uWjD5WSmO3dwtUfRx13rGfDpI9a0Igt/aG3yo=";
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
