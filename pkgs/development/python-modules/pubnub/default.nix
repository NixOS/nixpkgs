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
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python";
    rev = "v${version}";
    sha256 = "0f6r439bfz58ddikqj5cx56vv7gxrpja9rcdg0j1mlng8ry581f3";
  };

  propagatedBuildInputs = [
    cbor2
    pycryptodomex
    requests
    six
  ];

  checkInputs = [
    aiohttp
    pycryptodomex
    pytest-asyncio
    pytestCheckHook
    pytest-vcr

  ];

  # Some tests don't pass with recent releases of tornado/twisted
  pytestFlagsArray = [
    "--ignore tests/integrational"
    "--ignore tests/manual/asyncio"
    "--ignore tests/manual/tornado/test_reconnections.py"
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = with lib; {
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
