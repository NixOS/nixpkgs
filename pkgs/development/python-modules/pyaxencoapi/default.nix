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
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AXENCO-FR";
    repo = "ha-py-axenco-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ml58+kstIpqQUXDt/jpZeR8ueu5U3nnH7hiUcZxveAM=";
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
