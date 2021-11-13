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
, six
}:

buildPythonPackage rec {
  pname = "pubnub";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "v${version}";
    sha256 = "sha256-FyDsTqDQTI/Xxu4Sl4eHqwmgwN+ip+8WKGJs/h/kl2Y=";
  };

  propagatedBuildInputs = [
    aiohttp
    cbor2
    pycryptodomex
    requests
    six
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-vcr
  ];

  # Some tests don't pass with recent releases of twisted
  disabledTestPaths = [
    "tests/integrational"
    "tests/manual/asyncio"
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = with lib; {
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
