{
  aiohttp,
  aiohttp-sse-client,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "iometer";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iometer-gmbh";
    repo = "iometer.py";
    tag = finalAttrs.version;
    hash = "sha256-ksf/nZHv4/JRHo5OrFp6lgPF62DD37ELFfUVkL+TDEo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-sse-client
    yarl
  ];

  pythonImportsCheck = [ "iometer" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/test.py"
  ];

  meta = {
    changelog = "https://github.com/iometer-gmbh/iometer.py/releases/tag/${finalAttrs.src.tag}";
    description = "Python client for interacting with IOmeter devices over HTTP";
    homepage = "https://github.com/iometer-gmbh/iometer.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
