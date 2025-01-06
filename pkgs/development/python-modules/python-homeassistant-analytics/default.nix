{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  yarl,
  mashumaro,
  orjson,

  # tests
  pytestCheckHook,
  aioresponses,
  pytest-cov-stub,
  pytest-asyncio,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-homeassistant-analytics";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-homeassistant-analytics";
    tag = "v${version}";
    hash = "sha256-TfD1N4KoeIVoDp1YoOhBw8E7adow1nU1N6vj2j3W2No=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    aioresponses
    pytest-cov-stub
    pytest-asyncio
    syrupy
  ];

  pythonImportsCheck = [ "python_homeassistant_analytics" ];

  meta = with lib; {
    description = "Asynchronous Python client for Home Assistant Analytics";
    changelog = "https://github.com/joostlek/python-homeassistant-analytics/releases/tag/v${version}";
    homepage = "https://github.com/joostlek/python-homeassistant-analytics";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
