{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pyprojectVersionPatchHook,
  setuptools,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotractive";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mYf8WoY2GNaVuLnDMYhbLK4h1CUvZsKKegiM0hXfWtQ=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "orjson"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
