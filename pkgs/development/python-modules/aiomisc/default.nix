{
  lib,
  stdenv,
  aiocontextvars,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  colorlog,
  croniter,
  fastapi,
  fetchPypi,
  logging-journald,
  poetry-core,
  pytestCheckHook,
  raven,
  rich,
  setproctitle,
  uvloop,
}:

buildPythonPackage rec {
  pname = "aiomisc";
  version = "17.9.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qZcoKRXbBbRY2cTY2bTFTk+IpqJ5Pe+szfA76G7kJ+Q=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    colorlog
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ logging-journald ];

  nativeCheckInputs = [
    aiocontextvars
    async-timeout
    fastapi
    pytestCheckHook
    setproctitle
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    #asgi = [ aiohttp-asgi ];
    cron = [ croniter ];
    #carbon = [ aiocarbon ];
    raven = [
      aiohttp
      raven
    ];
    rich = [ rich ];
    uvloop = [ uvloop ];
  };

  pythonImportsCheck = [ "aiomisc" ];

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
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
