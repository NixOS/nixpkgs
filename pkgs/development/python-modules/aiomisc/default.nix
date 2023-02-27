{ lib
, aiocontextvars
  #, aiocarbon
, aiohttp
  #, aiohttp-asgi
, async-timeout
, buildPythonPackage
, colorlog
, croniter
, fastapi
, fetchPypi
, logging-journald
, pytestCheckHook
, pythonOlder
, raven
  #, raven-aiohttp
, setproctitle
, uvloop
}:

buildPythonPackage rec {
  pname = "aiomisc";
  version = "17.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qiB6dRJjRnvqmwbZUy7oV9U6norCM7pZSxRtkHCU3Jg=";
  };

  propagatedBuildInputs = [
    colorlog
    logging-journald
  ];

  nativeCheckInputs = [
    aiocontextvars
    async-timeout
    fastapi
    pytestCheckHook
    raven
    setproctitle
  ] ++ passthru.optional-dependencies.aiohttp
  ++ passthru.optional-dependencies.cron
  ++ passthru.optional-dependencies.uvloop;

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    #asgi = [
    #  aiohttp-asgi
    #];
    cron = [
      croniter
    ];
    #carbon = [
    #  aiocarbon
    #];
    #raven = [
    #  raven-aiohttp
    #];
    uvloop = [
      uvloop
    ];
  };

  pythonImportsCheck = [
    "aiomisc"
  ];

  # Upstream stopped tagging with 16.2
  doCheck = false;

  # disabledTestPaths = [
  #   # Dependencies are not available at the moment
  #   "tests/test_entrypoint.py"
  #   "tests/test_raven_service.py"
  # ];

  meta = with lib; {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
