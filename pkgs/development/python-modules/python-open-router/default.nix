{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  yarl,
  mashumaro,
  orjson,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  aioresponses,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-open-router";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-open-router";
    tag = "v${version}";
    hash = "sha256-SSpSoo82FD1KUwbZpeHpl9I4A50yuJmdTVaHDxLZXso=";
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
    pytest-asyncio
    pytest-cov-stub
    aioresponses
    syrupy
  ];

  pythonImportsCheck = [ "python_open_router" ];

  meta = {
    description = "Asynchronous Python client for Open Router";
    homepage = "https://github.com/joostlek/python-open-router";
    changelog = "https://github.com/joostlek/python-open-router/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
