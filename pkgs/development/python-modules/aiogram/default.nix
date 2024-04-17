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
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-2of4KHdpAATOt0dCqI3AmTJtdeN5SdiWydeGjtagABI=";
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
