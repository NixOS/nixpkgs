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
  pythonOlder,
  raven,
  rich,
  setproctitle,
  typing-extensions,
  uvloop,
}:

buildPythonPackage rec {
  pname = "aiomisc";
  version = "17.5.24";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9/7QI9z5dYADNRIWBelrUoNe/LaHqpb/Ch4e1Z9I1s4=";
  };

  build-system = [ poetry-core ];

  dependencies =
    [ colorlog ]
    ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ]
    ++ lib.optionals stdenv.isLinux [ logging-journald ];

  nativeCheckInputs = [
    aiocontextvars
    async-timeout
    fastapi
    pytestCheckHook
    setproctitle
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  passthru.optional-dependencies = {
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
