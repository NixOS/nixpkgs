{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiokarakeep";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sli-cka";
    repo = "aiokarakeep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FAFJfVnP1SEgt8jCET6oqS6DT/VtdFUTJ8l+HtWq5es=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiokarakeep" ];

  meta = {
    description = "Async Python client for the Karakeep API";
    homepage = "https://github.com/sli-cka/aiokarakeep";
    changelog = "https://github.com/sli-cka/aiokarakeep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
