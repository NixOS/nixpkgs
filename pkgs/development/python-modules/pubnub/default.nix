{ lib
, aiohttp
, buildPythonPackage
, cbor2
, fetchFromGitHub
, pycryptodomex
, pytestCheckHook
, pytest-vcr
, pytest-asyncio
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pubnub";
<<<<<<< HEAD
  version = "7.2.0";
=======
  version = "7.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-AUB6pk3Gkrjc0RRFP0mql+up1baPjyPwuiRz8O6r/GM=";
=======
    hash = "sha256-+g/VBxv0XfqqwTEKtgBAy7Pfakll00JXMFBS2q3pHn8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    cbor2
    pycryptodomex
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-vcr
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/integrational"
    "tests/manual"
    "tests/functional/push"
  ];

  pythonImportsCheck = [
    "pubnub"
  ];

  meta = with lib; {
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    changelog = "https://github.com/pubnub/python/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
