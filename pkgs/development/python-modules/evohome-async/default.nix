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
  hatch-vcs,
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
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6J61wNwNg87dFFxvvh0aFNJp3g9BzAcOmwTIZFOBvkM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

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
