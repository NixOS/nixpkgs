{
  # Basic
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  setuptools,
  # Dependencies
  aiohttp,
  requests,
  websocket-client,
  cryptography,
  certifi,
  # Test
  pytestCheckHook,
  tiktoken,
}:

buildPythonPackage rec {
  pname = "dashscope";
  version = "1.24.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dashscope";
    repo = "dashscope-sdk-python";
    tag = "v${version}";
    hash = "sha256-kHvNg8yPlZyAr7Qgncv+axgG9sOKTjvxYnRojO5ih1g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    websocket-client
    cryptography
    certifi
  ];

  # Specify the version explicitly
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=get_version()," "version='${version}',"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    tiktoken
  ];

  pythonImportsCheck = [ "dashscope" ];

  disabledTests = [
    # Needs network access and/or API key
    "TestAsyncImageSynthesisRequest"
    "TestAsyncRequest"
    "TestAsyncVideoSynthesisRequest"
    "TestEncryption"
    "TestSpeechRecognition"
    "TestSpeechTranscribe"
    "TestSynthesis"
    "TestWebSocketAsyncRequest"
    "TestWebSocketSyncRequest"
  ];

  meta = {
    description = "Python SDK for dashscope";
    homepage = "https://github.com/dashscope/dashscope-sdk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thattemperature ];
  };
}
