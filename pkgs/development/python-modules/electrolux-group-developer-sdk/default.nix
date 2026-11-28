{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  pydantic,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "electrolux-group-developer-sdk";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "electrolux-oss";
    repo = "electrolux-group-developer-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qZ/qdyKmsu3P5KOnB3dpzYhjux1DjUk/NyCVbP7Et/g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pydantic
    pyjwt
    tzdata
  ];

  nativeCheckInputs = [
    # Upstream uses the aioresponses-ng fork for the same mocking API.
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "electrolux_group_developer_sdk" ];

  meta = {
    description = "Asynchronous Python client for the Electrolux Developer Portal API";
    homepage = "https://github.com/electrolux-oss/electrolux-group-developer-sdk";
    changelog = "https://github.com/electrolux-oss/electrolux-group-developer-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
