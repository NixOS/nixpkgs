{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  buildPythonPackage,
  deepmerge,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioipp";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "brianegge";
    repo = "aioipp";
    tag = finalAttrs.version;
    hash = "sha256-ircGvIr4GXGdCc1EL5EZQde+/MGf+8gggEm4lmuyfOo=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    deepmerge
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyipp" ];

  meta = {
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/brianegge/aioipp";
    changelog = "https://github.com/brianegge/aioipp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
