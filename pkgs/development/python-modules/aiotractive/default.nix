{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  setuptools,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotractive";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tr8USF7GF9CMOcjy62e+oTu4k/1jIAOsZmWTFWEzJvk=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "orjson" ];

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
