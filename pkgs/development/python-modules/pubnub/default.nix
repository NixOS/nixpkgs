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
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pubnub";
  version = "10.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pubnub";
    repo = "python";
    tag = finalAttrs.version;
    hash = "sha256-EZfJ+DAZdaF1jf2nU2dUXZ7tQlGNXUMsIGyj4cjmdOs=";
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
    # Examples
    "tests/examples"
  ];

  disabledTests = [
    "test_subscribe"
    "test_handshaking"
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = {
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    changelog = "https://github.com/pubnub/python/releases/tag/${finalAttrs.src.tag}";
    # PubNub Software Development Kit License Agreement
    # https://github.com/pubnub/python/blob/master/LICENSE
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ fab ];
  };
})
