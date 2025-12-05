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

buildPythonPackage rec {
  pname = "mozart-api";
  version = "5.1.0.247.1";
  pyproject = true;

  src = fetchPypi {
    pname = "mozart_api";
    inherit version;
    hash = "sha256-//4mJh+Vf/NdnQmX19EOhn+Lx+BTMbZE5xwG6kXs84Y=";
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
    changelog = "https://github.com/bang-olufsen/mozart-open-api/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
