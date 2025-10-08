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
  version = "4.29.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "eternnoir";
    repo = "pyTelegramBotAPI";
    tag = version;
    hash = "sha256-djiuIHTcPiKIfMxFevCa4c3V8ydGpSqH4mo0qH+Cpw8=";
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
  ]
  ++ optional-dependencies.watchdog
  ++ optional-dependencies.aiohttp;

  pythonImportsCheck = [ "telebot" ];

  meta = with lib; {
    description = "Python implementation for the Telegram Bot API";
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    changelog = "https://github.com/eternnoir/pyTelegramBotAPI/releases/tag/${src.tag}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ das_j ];
  };
}
