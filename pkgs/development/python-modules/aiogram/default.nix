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
  pythonOlder,
  pytz,
  redis,
  uvloop,
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "3.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-uTFh1ncIPF9SmAEVGeBnXEKrYzgifZan1sxk5UiG92U=";
  };

  build-system = [ hatchling ];

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
  };

  nativeCheckInputs = [
    aresponses
    pycryptodomex
    pytest-aiohttp
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    pytz
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlagsArray = [
    "-W"
    "ignore::pluggy.PluggyTeardownRaisedWarning"
    "-W"
    "ignore::pytest.PytestDeprecationWarning"
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "aiogram" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
