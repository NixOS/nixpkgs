{
  lib,
  aiohttp,
  aioresponses,
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

buildPythonPackage (finalAttrs: {
  pname = "python-overseerr";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-overseerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tpwh84c9js79X85UXI01Hv5yr1+KUatyuTkY3nNQhxs=";
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
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "python_overseerr" ];

  disabledTests = [
    # Test requires network access to the Overseerr API
    "test_search_with_encoded_spaces"
  ];

  meta = {
    description = "Client for Overseerr";
    homepage = "https://github.com/joostlek/python-overseerr";
    changelog = "https://github.com/joostlek/python-overseerr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
