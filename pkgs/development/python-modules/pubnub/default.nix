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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pubnub";
<<<<<<< HEAD
  version = "10.5.0";
  pyproject = true;

=======
  version = "10.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "pubnub";
    repo = "python";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-4EqP3HZuSXYB5P6xvPuwTou/2zHS0ClaAy42knbCMhc=";
=======
    hash = "sha256-NI7rEudQ5sSj6cpPpFxEcqaeiQL6dJKK7C53BTJeMAg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python-based APIs for PubNub";
    homepage = "https://github.com/pubnub/python";
    changelog = "https://github.com/pubnub/python/releases/tag/${src.tag}";
    # PubNub Software Development Kit License Agreement
    # https://github.com/pubnub/python/blob/master/LICENSE
<<<<<<< HEAD
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
