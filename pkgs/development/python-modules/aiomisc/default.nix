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
, fetchFromGitHub
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
  version = "16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiokitchen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wxm7MrFHZ7TrUGw5w7iLWs1olU8ZmJmJ7M/BZ6Nf0fU=";
  };

  propagatedBuildInputs = [
    colorlog
    logging-journald
  ];

  checkInputs = [
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

  disabledTestPaths = [
    # Dependencies are not available at the moment
    "tests/test_entrypoint.py"
    "tests/test_raven_service.py"
  ];

  meta = with lib; {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
