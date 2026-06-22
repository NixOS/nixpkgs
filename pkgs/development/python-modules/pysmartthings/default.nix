{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmartthings";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pysmartthings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yxGrtEMWMargZ9i0b4DqxSh/x3pbK1J8unL7goGnURY=";
  };

  build-system = [ hatchling ];

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

  pythonImportsCheck = [ "pysmartthings" ];

  meta = {
    description = "Python library for interacting with the SmartThings cloud API";
    homepage = "https://github.com/andrewsayre/pysmartthings";
    changelog = "https://github.com/andrewsayre/pysmartthings/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
