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
  version = "17.9.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c9dlFc6XFahTbg6EEBb1OiKpFJ/zlzIp34UQJc8CXKY=";
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
