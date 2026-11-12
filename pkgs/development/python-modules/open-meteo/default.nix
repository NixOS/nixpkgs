{
  lib,
  aiohttp,
  aioresponses,
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

buildPythonPackage (finalAttrs: {
  pname = "open-meteo";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-open-meteo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rTHHqFiar2W5LTuuXKfUv0tnvjXuNbkfzT80DWXpYiE=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "open_meteo" ];

  meta = {
    changelog = "https://github.com/frenck/python-open-meteo/releases/tag/${finalAttrs.version}";
    description = "Python client for the Open-Meteo API";
    homepage = "https://github.com/frenck/python-open-meteo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
