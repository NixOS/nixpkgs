{ lib
, aenum
, aioconsole
, aiohttp
, aiohttp-retry
, buildPythonPackage
, fetchPypi
, inflection
, poetry-core
, pydantic
, python-dateutil
, pythonOlder
, typing-extensions
, urllib3
, pythonRelaxDepsHook
, websockets
, zeroconf
}:

buildPythonPackage rec {
  pname = "mozart-api";
  version = "3.4.1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "mozart_api";
    inherit version;
    hash = "sha256-SxKJ+w99rybxutd35JYKJCSo5fTPuwGrAmBggD9Ud4M=";
  };

  pythonRelaxDeps = [
    "pydantic"
  ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
    aenum
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

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mozart_api"
  ];

  meta = with lib; {
    description = "Module for the Mozart platform API";
    homepage = "https://pypi.org/project/mozart-api";
    changelog = "https://github.com/bang-olufsen/mozart-open-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
