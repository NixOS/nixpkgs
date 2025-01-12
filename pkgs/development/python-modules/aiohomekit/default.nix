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
  commentjson,
  cryptography,
  fetchFromGitHub,
  orjson,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "aiohomekit";
  version = "3.2.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiohomekit";
    rev = "refs/tags/${version}";
    hash = "sha256-2mo7huHnac17FzBK0z1iCFOTkTUBohvOVUJ1226w7Ks=";
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
    commentjson
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

  meta = with lib; {
    description = "Python module that implements the HomeKit protocol";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    changelog = "https://github.com/Jc2k/aiohomekit/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "aiohomekitctl";
  };
}
