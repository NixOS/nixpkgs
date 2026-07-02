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
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  raven,
  rich,
  setproctitle,
  uvloop,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomisc";
  version = "17.10.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-24ka982Wx4Bk2TlWuw6pvfRLh47l8QJvHD+sc+LOxVY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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

  meta = {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
