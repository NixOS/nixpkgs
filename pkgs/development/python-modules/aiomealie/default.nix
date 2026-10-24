{
  lib,
  aiohttp,
  aiointercept,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomealie";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-mealie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yf/16+Yi7Wvafl9mH5ah6SYbMtrhIXsn/4ajyjidR+M=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    aiohttp
    awesomeversion
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

  pythonImportsCheck = [ "aiomealie" ];

  meta = {
    description = "Module to interact with Mealie";
    homepage = "https://github.com/joostlek/python-mealie";
    changelog = "https://github.com/joostlek/python-mealie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
