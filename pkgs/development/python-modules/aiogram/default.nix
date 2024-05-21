{
  lib,
  aiofiles,
  aiohttp,
  aiohttp-socks,
  aresponses,
  babel,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  gitUpdater,
  hatchling,
  magic-filter,
  pycryptodomex,
  pydantic,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-lazy-fixture,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  pytz,
  redis,
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-8hbB6/j9mWONFNpQuC3p91xnHR/74TWA9Cq8E+Gsnlw=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pydantic" ];

  dependencies = [
    aiofiles
    aiohttp
    babel
    certifi
    magic-filter
    pydantic
  ];

  nativeCheckInputs = [
    aiohttp-socks
    aresponses
    pycryptodomex
    pytest-aiohttp
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    pytz
    redis
  ];

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

  meta = with lib; {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
