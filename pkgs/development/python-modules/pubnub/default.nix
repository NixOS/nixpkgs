{
  lib,
  aiohttp,
  buildPythonPackage,
  busypie,
  cbor2,
  fetchFromGitHub,
  h2,
  httpx,
  pycryptodomex,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pubnub";
  version = "10.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pubnub";
    repo = "python";
    tag = version;
    hash = "sha256-9qy2ltxDKpEcfgDQDOqhZnEQSLk1VFE5WInJkz8YWCM=";
  };

  pythonRelaxDeps = [ "httpx" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cbor2
    h2
    httpx
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
    changelog = "https://github.com/pubnub/python/releases/tag/${src.tag}";
    # PubNub Software Development Kit License Agreement
    # https://github.com/pubnub/python/blob/master/LICENSE
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ fab ];
  };
}
