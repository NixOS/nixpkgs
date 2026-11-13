{
  lib,
  aiofiles,
  aiohttp,
  aiozoneinfo,
  asyncclick,
  buildPythonPackage,
  debugpy,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  keyring,
  probatio,
  pytest-asyncio,
  pytest-freezer,
  pytestCheckHook,
  pyyaml,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "evohome-async";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NoaW5wSOdYcWXPuK/mqSwaVoeh8N0uyNw08ih/729WM=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    aiozoneinfo
    probatio
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
