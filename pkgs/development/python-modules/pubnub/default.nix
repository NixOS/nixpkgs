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
  version = "6.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-HeblPnHSGO12+2hNvwRde84hvjdkxEJU6Eygxs36UBE=";
  };

  propagatedBuildInputs = [
    aiohttp
    cbor2
    pycryptodomex
    requests
  ];

  checkInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
