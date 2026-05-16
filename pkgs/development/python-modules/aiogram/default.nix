{
  lib,
  aiodns,
  aiofiles,
  aiohttp-socks,
  aiohttp,
  aresponses,
  babel,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  gitUpdater,
  hatchling,
  magic-filter,
  motor,
  pycryptodomex,
  pydantic,
  pymongo,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-lazy-fixture,
  pytestCheckHook,
  pytz,
  redis,
  uvloop,
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "3.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    tag = "v${version}";
    hash = "sha256-jy0OOeDiDh2ff3wIR6mYc8P8dOIgVeK0WVQYeug4yEI=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "aiohttp" ];

  dependencies = [
    aiofiles
    aiohttp
    certifi
    magic-filter
    pydantic
  ];

  optional-dependencies = {
    fast = [
      aiodns
      uvloop
    ];
    mongo = [
      motor
      pymongo
    ];
    redis = [ redis ];
    proxy = [ aiohttp-socks ];
    i18n = [ babel ];
    signature = [ cryptography ];
  };

  nativeCheckInputs = [
    aresponses
    pycryptodomex
    pytest-aiohttp
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    pytz
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    # DeprecationWarning: 'asyncio.get_event_loop_policy' is deprecated and slate...
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "aiogram" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "4.1";
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
