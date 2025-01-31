{
  lib,
  aiohttp,
  aioredis,
  buildPythonPackage,
  coloredlogs,
  fastapi,
  fetchFromGitHub,
  hatchling,
  pillow,
  psutil,
  pytestCheckHook,
  pythonOlder,
  redis,
  requests,
  ujson,
  uvicorn,
  watchdog,
}:

buildPythonPackage rec {
  pname = "pytelegrambotapi";
  version = "4.24.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eternnoir";
    repo = "pyTelegramBotAPI";
    rev = "refs/tags/${version}";
    hash = "sha256-/QzLF6q3ygMLElLd8qMZ97Bv1KMOl8Dctv5QGjiRCKo=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    json = [ ujson ];
    PIL = [ pillow ];
    redis = [ redis ];
    aioredis = [ aioredis ];
    aiohttp = [ aiohttp ];
    fastapi = [ fastapi ];
    uvicorn = [ uvicorn ];
    psutil = [ psutil ];
    coloredlogs = [ coloredlogs ];
    watchdog = [ watchdog ];
  };

  checkInputs = [
    pytestCheckHook
    requests
  ] ++ optional-dependencies.watchdog ++ optional-dependencies.aiohttp;

  pythonImportsCheck = [ "telebot" ];

  meta = with lib; {
    description = "Python implementation for the Telegram Bot API";
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    changelog = "https://github.com/eternnoir/pyTelegramBotAPI/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ das_j ];
  };
}
