{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioanylist";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BookCatKid";
    repo = "aioanylist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LaDnPsjYbIumGmTBvh4TgwjDa7uA/BflP6bflOoGCg4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    protobuf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Type checks
    "mypy"
  ];

  pythonImportsCheck = [ "aioanylist" ];

  meta = {
    description = "Async client for AnyList";
    homepage = "https://github.com/BookCatKid/aioanylist";
    changelog = "https://github.com/BookCatKid/aioanylist/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
