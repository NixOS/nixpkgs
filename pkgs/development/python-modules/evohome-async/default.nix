{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  aiozoneinfo,
  asyncclick,
  buildPythonPackage,
  debugpy,
  fetchFromGitHub,
  hatchling,
  keyring,
  pytest-asyncio,
  pytest-freezer,
  pytestCheckHook,
  pyyaml,
  syrupy,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "evohome-async";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CbC5ms3YcNB6n5UmCHfHKTtyJau68m8QZ5UwRyiR9MM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiozoneinfo
    voluptuous
  ];

  optional-dependencies = {
    cli = [
      aiofiles
      asyncclick
      debugpy
      keyring
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-freezer
    pytestCheckHook
    pyyaml
    syrupy
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  pythonImportsCheck = [ "evohomeasync2" ];

  meta = {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    changelog = "https://github.com/zxdavb/evohome-async/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evo-client";
  };
})
