{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, aiohttp
, aiohttp-socks
, aioredis
, aiofiles
, aresponses
, babel
, certifi
, magic-filter
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
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-TD4pDmM899zBOxllM0iju2u6IhmXxLYWBpjfWhewVFc=";
  };

  nativeBuildInputs = [
    hatchling
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
    aioredis
    aresponses
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    pytz
    redis
  ];

  # import failures
  disabledTests = [
    "test_aiohtt_server"
    "test_deep_linking"
  ];

  pythonImportsCheck = [ "aiogram" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
