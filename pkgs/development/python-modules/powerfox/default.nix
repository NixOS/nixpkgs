{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy_6,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "powerfox";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-powerfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-290ZCJZk/aFGlGpSpreSMh+sXBJDw+d37sANvIBhwgg=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy_6
  ];

  pythonImportsCheck = [ "powerfox" ];

  meta = {
    description = "Asynchronous Python client for the Powerfox devices";
    homepage = "https://github.com/klaasnicolaas/python-powerfox";
    changelog = "https://github.com/klaasnicolaas/python-powerfox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
