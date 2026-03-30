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
  pytest-asyncio,
  pytest-freezer,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  syrupy,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "evohome-async";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xc5GWbKqgcIIHKBvcAIS8zL9rZeEDEkwHOhhUdnImbE=";
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
