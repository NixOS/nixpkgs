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
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-hotspring";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "python-hotspring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TE/Gp2jXHjm3iSdh6aGg9ieT+OISype5CYTp17SdVxs=";
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
