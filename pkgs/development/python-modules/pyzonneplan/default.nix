{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hatchling,
  mashumaro,
  orjson,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  tenacity,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzonneplan";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyzonneplan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BL1Nik4zDOt8b0bw2y1mX+T3Ze6gqQS1EVszaTfUVaQ=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    tenacity
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pyzonneplan" ];

  meta = {
    description = "Asynchronous Python client for the Zonneplan API";
    homepage = "https://github.com/erwindouna/pyzonneplan";
    changelog = "https://github.com/erwindouna/pyzonneplan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
