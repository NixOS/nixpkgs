{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  aenum,
  aioconsole,
  aiohttp,
  aiohttp-retry,
  inflection,
  pydantic,
  python-dateutil,
  typing-extensions,
  urllib3,
  websockets,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "mozart-api";
  version = "5.3.1.108.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mozart_api";
    inherit (finalAttrs) version;
    hash = "sha256-ilUSGgc4m6iMBUuSI7qt7c4DAE8cOPTzLGeQ4JQAB8U=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aioconsole
    aiohttp
    aiohttp-retry
    inflection
    pydantic
    python-dateutil
    typing-extensions
    urllib3
    websockets
    zeroconf
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "mozart_api" ];

  meta = {
    description = "REST API for the Bang & Olufsen Mozart platform";
    homepage = "https://github.com/bang-olufsen/mozart-open-api";
    changelog = "https://github.com/bang-olufsen/mozart-open-api/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
