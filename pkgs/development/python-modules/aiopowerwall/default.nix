{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  cryptography,
  protobuf,
  tesla-protocol,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopowerwall";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "aiopowerwall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-be6q7Wn8OMHMPkNJSR/E4Ah0j4Clz9dj1YG4irpLqW8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    cryptography
    protobuf
    tesla-protocol
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopowerwall" ];

  meta = {
    description = "Async Tesla Powerwall 3 client over the TEDAPI v1r RSA-signed LAN protocol";
    homepage = "https://github.com/Teslemetry/aiopowerwall";
    changelog = "https://github.com/Teslemetry/aiopowerwall/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
