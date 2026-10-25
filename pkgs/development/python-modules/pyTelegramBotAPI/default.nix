{
  lib,
  aiohttp,
  buildPythonPackage,
  coloredlogs,
  fastapi,
  fetchFromGitHub,
  hatchling,
  pillow,
  psutil,
  pytestCheckHook,
  redis,
  requests,
  ujson,
  uvicorn,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytelegrambotapi";
  version = "4.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eternnoir";
    repo = "pyTelegramBotAPI";
    tag = finalAttrs.version;
    hash = "sha256-RVrCL/fwPiKUylMxush5TkRk2qb7mMPmKCrLq1z7nJg=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    json = [ ujson ];
    PIL = [ pillow ];
    redis = [ redis ];
    aiohttp = [ aiohttp ];
    fastapi = [ fastapi ];
    uvicorn = [ uvicorn ];
    psutil = [ psutil ];
    coloredlogs = [ coloredlogs ];
    watchdog = [ watchdog ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "telebot" ];

  meta = {
    description = "Python implementation for the Telegram Bot API";
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    changelog = "https://github.com/eternnoir/pyTelegramBotAPI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
