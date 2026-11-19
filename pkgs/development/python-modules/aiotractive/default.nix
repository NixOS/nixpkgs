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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aQJ9TWkX42Svv2q3KPVwlqE8jgCD+yQTLT9xBHMFDEY=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "orjson"
  ];

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
