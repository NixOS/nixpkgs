{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-melcloud";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "python-melcloud";
    tag = version;
    hash = "sha256-1WFE8k16aDIp1S/WDHXVdUtQmISEoE8yQAn9nndmQWs=";
  };

  build-system = [ poetry-core ];

  pythonRemoveDeps = [
    "aioresponses"
    "mashumaro"
    "orjson"
    "yarl"
  ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pymelcloud" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/erwindouna/python-melcloud/blob/${src.tag}/CHANGELOG.md";
    description = "Asynchronous Python client for controlling Melcloud devices";
    homepage = "https://github.com/erwindouna/python-melcloud";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
