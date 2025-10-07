{
  lib,
  aiolimiter,
  apscheduler,
  beautifulsoup4,
  buildPythonPackage,
  cachetools,
  cffi,
  cryptography,
  fetchFromGitHub,
  flaky,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "22.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-telegram-bot";
    repo = "python-telegram-bot";
    tag = "v${version}";
    hash = "sha256-++vDura+7AkqM7gV12O2CRRQ1H7G5G22VHGo4OdyffU=";
  };

  build-system = [
    setuptools
    hatchling
  ];

  dependencies = [ httpx ];

  optional-dependencies = rec {
    all = ext ++ http2 ++ passport ++ socks;
    callback-data = [ cachetools ];
    ext = callback-data ++ job-queue ++ rate-limiter ++ webhooks;
    http2 = httpx.optional-dependencies.http2;
    job-queue = [
      apscheduler
      pytz
    ];
    passport = [ cryptography ] ++ lib.optionals (pythonAtLeast "3.13") [ cffi ];
    rate-limiter = [ aiolimiter ];
    socks = httpx.optional-dependencies.socks;
    webhooks = [ tornado ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    flaky
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  pythonImportsCheck = [ "telegram" ];

  disabledTests = [
    # Tests require network access
    "TestAIO"
    "TestAnimation"
    "TestApplication"
    "TestAudio"
    "TestBase"
    "TestBot"
    "TestCallback"
    "TestChat"
    "TestChosenInlineResult"
    "TestCommandHandler"
    "TestConstants"
    "TestContact"
    "TestConversationHandler"
    "TestDice"
    "TestDict"
    "TestDocument"
    "TestFile"
    "TestForceReply"
    "TestForum"
    "TestGame"
    "TestGet"
    "TestGiftsWithRequest"
    "TestHTTP"
    "TestInline"
    "TestInput"
    "TestInvoice"
    "TestJob"
    "TestKeyboard"
    "TestLocation"
    "TestMask"
    "TestMenu"
    "TestMessage"
    "TestMeta"
    "TestOrder"
    "TestPassport"
    "TestPhoto"
    "TestPickle"
    "TestPoll"
    "TestPre"
    "TestPrefix"
    "TestProximity"
    "TestReply"
    "TestRequest"
    "TestSend"
    "TestSent"
    "TestShipping"
    "TestSlot"
    "TestSticker"
    "TestString"
    "TestSuccess"
    "TestTelegram"
    "TestType"
    "TestUpdate"
    "TestUser"
    "TestVenue"
    "TestVideo"
    "TestVoice"
    "TestWeb"
  ];

  meta = with lib; {
    description = "Python library to interface with the Telegram Bot API";
    homepage = "https://python-telegram-bot.org";
    changelog = "https://github.com/python-telegram-bot/python-telegram-bot/blob/${src.tag}/CHANGES.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      veprbl
      pingiun
    ];
  };
}
