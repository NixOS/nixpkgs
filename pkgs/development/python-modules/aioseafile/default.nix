{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  orjson,
  pyprojectVersionPatchHook,
  pytest-asyncio_0,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  tenacity,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioseafile";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "aioseafile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fFeaiGFYlU4bQ5rgRgttAgjWsgS1EXxyrLhnLnBQ7eQ=";
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
    pytest-asyncio_0
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  # aresponses uses pytest-asyncio 0.x, which evaluates type-only imports during collection.
  preCheck = ''
    sed -i '1i from __future__ import annotations' tests/conftest.py tests/test_*.py
  '';

  pythonImportsCheck = [ "aioseafile" ];

  meta = {
    description = "Asynchronous Python client for the Seafile Web API";
    homepage = "https://github.com/erwindouna/aioseafile";
    changelog = "https://github.com/erwindouna/aioseafile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
