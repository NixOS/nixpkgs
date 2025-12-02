{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  pytestCheckHook,
  pytest-aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-cors";
    tag = "v${version}";
    hash = "sha256-AbMuUeCNM8+oZj/hutG3zxHOwYN8uZlLFBeYTlu1fh4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "aiohttp_cors" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  disabledTests = [
    # async def functions are not natively supported and have been skipped.
    "test_main"
    "test_defaults"
    "test_raises_forbidden_when_config_not_found"
    "test_raises_when_handler_not_extend"
  ];

  # interactive browser tests using selenium
  disabledTestPaths = [ "tests/integration" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/aiohttp-cors/blob/${src.tag}/CHANGES.rst";
    description = "CORS support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-cors";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
