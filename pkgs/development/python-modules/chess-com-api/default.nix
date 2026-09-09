{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "chess-com-api";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stupidoodle";
    repo = "chess-com-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/84rDQwD1Qxl1x7AOF6KFTYqYOdqQyzuhgiz5gArMmo=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
  ];

  disabledTestPaths = [
    # require network access
    "tests/test_client.py"
    "tests/test_integration.py"
  ];

  pythonImportsCheck = [ "chess_com_api" ];

  meta = {
    description = "An async Python wrapper for the Chess.com API";
    homepage = "https://github.com/Stupidoodle/chess-com-api";
    changelog = "https://github.com/Stupidoodle/chess-com-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
