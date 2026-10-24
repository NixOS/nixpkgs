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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyzonneplan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uvNp/yP6k+qLlBXQmh0gM4kbFS8uAZfyonMGCvxbn38=";
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
