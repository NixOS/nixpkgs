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
  pname = "python-overseerr";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-overseerr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9sJWglF1EqwXG0Cj1hOtNE2dYTmxIZoVWHYT5I4RQu0=";
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
