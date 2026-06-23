{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-homeassistant-analytics";
    tag = "v${version}";
    hash = "sha256-Deh3pZKpqdrlgv6LQk3NHuATz3porWiM8dewjbdbR7M=";
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

  meta = {
    description = "Asynchronous Python client for Home Assistant Analytics";
    changelog = "https://github.com/joostlek/python-homeassistant-analytics/releases/tag/v${version}";
    homepage = "https://github.com/joostlek/python-homeassistant-analytics";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
