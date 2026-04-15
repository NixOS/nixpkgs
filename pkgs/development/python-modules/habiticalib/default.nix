{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  mashumaro,
  orjson,
  pillow,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "habiticalib";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "habiticalib";
    tag = "v${version}";
    hash = "sha256-ZZY7UnA4d4JNHGLMtaEGobAgzAwYDgL2SUGfxGABxTs=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  pythonRelaxDeps = [
    "orjson"
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    pillow
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "habiticalib" ];

  disabledTests = [
    # AssertionError
    "test_generate_avatar"
  ];

  meta = {
    description = "Library for the Habitica API";
    homepage = "https://github.com/tr4nt0r/habiticalib";
    changelog = "https://github.com/tr4nt0r/habiticalib/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
