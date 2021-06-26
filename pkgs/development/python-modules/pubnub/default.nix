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
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "v${version}";
    sha256 = "0mpw2wzbpb60lnrsnw8mc88mxxhslpnc5nvkjyc3v2dbqs5cnmy5";
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
