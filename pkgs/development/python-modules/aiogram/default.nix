{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, pytestCheckHook
, aiohttp
, aiohttp-socks
, aiofiles
, aresponses
, babel
, certifi
, magic-filter
, pycryptodomex
, pytest-aiohttp
, pytest-asyncio
, pytest-lazy-fixture
, redis
, hatchling
, pydantic
, pytz
, gitUpdater
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-NOaI01Lb969Lp/v38u2UipN9UbOQNJQEbN2JS3lmFno=";
  };

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  propagatedBuildInputs = [
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
    "-W" "ignore::pluggy.PluggyTeardownRaisedWarning"
    "-W" "ignore::pytest.PytestDeprecationWarning"
    "-W"  "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "aiogram" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
