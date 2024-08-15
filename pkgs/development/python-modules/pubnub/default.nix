{
  lib,
  aiohttp,
  buildPythonPackage,
  busypie,
  cbor2,
  fetchFromGitHub,
  pycryptodomex,
  pytestCheckHook,
  pytest-vcr,
  pytest-asyncio,
  requests,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pubnub";
  version = "8.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pubnub";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-c6NSwDl0rV5t9dELuVVbRiLXYzxcYhiLc6yV4QoErTs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cbor2
    pycryptodomex
    requests
  ];

  nativeCheckInputs = [
    busypie
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

  disabledTests = [
    "test_subscribe"
    "test_handshaking"
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = with lib; {
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    changelog = "https://github.com/pubnub/python/releases/tag/v${version}";
    # PubNub Software Development Kit License Agreement
    # https://github.com/pubnub/python/blob/master/LICENSE
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ fab ];
  };
}
