{
  lib,
  aiohttp,
  aioresponses,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pint,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiocomelit";
  version = "2.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T48aRtuF9eNrW5L97CGkjc2PCdRzbuGCvhdWCuqe7yk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    pint
  ];

  nativeCheckInputs = [
    aioresponses
    anyio
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
