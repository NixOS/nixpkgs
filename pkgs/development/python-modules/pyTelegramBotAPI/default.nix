{ lib
, aiohttp
, aioredis
, buildPythonPackage
, coloredlogs
, fastapi
, fetchFromGitHub
, pillow
, psutil
, pytestCheckHook
, pythonOlder
, redis
, requests
, ujson
, uvicorn
, watchdog
}:

buildPythonPackage rec {
  pname = "pytelegrambotapi";
<<<<<<< HEAD
  version = "4.13.0";
=======
  version = "4.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eternnoir";
    repo = "pyTelegramBotAPI";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-5P0DfQL8lwCY4nvp5efB7fO7YyBMTRaB4qflkc+Arso=";
=======
    hash = "sha256-K81B8cNQ5Vvu8nH8kiroeffwRaUIKpwnpX2Jq7xPjB0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.optional-dependencies = {
    json = [
      ujson
    ];
    PIL = [
      pillow
    ];
    redis = [
      redis
    ];
    aioredis = [
      aioredis
    ];
    aiohttp = [
      aiohttp
    ];
    fastapi = [
      fastapi
    ];
    uvicorn = [
      uvicorn
    ];
    psutil = [
      psutil
    ];
    coloredlogs = [
      coloredlogs
    ];
    watchdog = [
      watchdog
    ];
  };

  checkInputs = [
    pytestCheckHook
    requests
  ] ++ passthru.optional-dependencies.watchdog
  ++ passthru.optional-dependencies.aiohttp;

  pythonImportsCheck = [
    "telebot"
  ];

  meta = with lib; {
    description = "Python implementation for the Telegram Bot API";
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    changelog = "https://github.com/eternnoir/pyTelegramBotAPI/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ das_j ];
  };
}
