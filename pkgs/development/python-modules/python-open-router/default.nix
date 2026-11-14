{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-open-router";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-open-router";
    tag = "v${version}";
    hash = "sha256-Bl+BQePvH4rgGCH4uXS3yVDTGP0XfSId0UdMrfThF0I=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
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
