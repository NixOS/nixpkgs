{
  lib,
  aiohttp,
  aioresponses,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pint,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiocomelit";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pjCjlgL/KqCDh/s2ALuf0xU90hsonae1j1E3KqGhnbM=";
  };

  pythonRelaxBuildSystem = true;

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    pint
  ];

  nativeCheckInputs = [
    aioresponses
    anyio
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "aiocomelit" ];

  meta = {
    description = "Library to control Comelit Simplehome";
    homepage = "https://github.com/chemelli74/aiocomelit";
    changelog = "https://github.com/chemelli74/aiocomelit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
