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
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "v${version}";
    sha256 = "1jd3rr8dydfaxz5g8idpwacp4bnbmhg74dwz7qwmzn34336s4ji6";
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
