{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  habitipy,
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
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "habiticalib";
    tag = "v${version}";
    hash = "sha256-RHR7kXZkzv7wZ0napAT7Ukb4tJ2TiwmeZHiw20YpNkM=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [
    aiohttp
    habitipy
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

  pytestFlags = [ "--snapshot-update" ];

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
