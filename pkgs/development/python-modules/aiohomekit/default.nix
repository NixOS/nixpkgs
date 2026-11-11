{
  lib,
  buildPythonPackage,
  aiocoap,
  aiohappyeyeballs,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  chacha20poly1305,
  chacha20poly1305-reuseable,
  cryptography,
  fetchFromGitHub,
  orjson,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomekit";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiohomekit";
    tag = finalAttrs.version;
    hash = "sha256-ozVIT9JGi4rcW3LRcp1QR1kj0gl5APLv9y4Imqe99yE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiocoap
    aiohappyeyeballs
    async-interrupt
    bleak
    bleak-retry-connector
    chacha20poly1305
    chacha20poly1305-reuseable
    cryptography
    orjson
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_ip_pairing.py"
  ];

  pythonImportsCheck = [ "aiohomekit" ];

  meta = {
    description = "Python module that implements the HomeKit protocol";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    changelog = "https://github.com/Jc2k/aiohomekit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "aiohomekitctl";
  };
})
