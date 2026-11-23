{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-backoff,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-hotspring";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "python-hotspring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V9oYY3skGwiBsC5fmr7w/1LPHGLcCsa5Di21JLkIZUA=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    awesomeversion
    python-backoff
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "hotspring" ];

  meta = {
    description = "Asynchronous Python client for Hot Spring Connected Spa Kit 2";
    homepage = "https://github.com/Moustachauve/python-hotspring";
    changelog = "https://github.com/Moustachauve/python-hotspring/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
