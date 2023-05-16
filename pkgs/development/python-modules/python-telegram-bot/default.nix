{ lib
, aiolimiter
, apscheduler
, beautifulsoup4
, buildPythonPackage
, cachetools
, cryptography
, fetchFromGitHub
, flaky
, httpx
, pytest-asyncio
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pytz
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tornado
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
<<<<<<< HEAD
  version = "20.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "20.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-/AdGpOl87EeVDCAZLjtan7ttE2vUL0gi1qeM18ilYEQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    hash = "sha256-OdjTlVUjlw+5K/kvL1Yx+7c/lIE52udUo6Ux18M9xmE=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aiolimiter
    apscheduler
    cachetools
    cryptography
    httpx
    pytz
  ]
  ++ httpx.optional-dependencies.socks
  ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    beautifulsoup4
    flaky
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    tornado
  ];

  pythonImportsCheck = [
    "telegram"
  ];

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
    changelog = "https://github.com/python-telegram-bot/python-telegram-bot/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ veprbl pingiun ];
  };
}
