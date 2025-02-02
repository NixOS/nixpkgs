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
  version = "3.1.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiohomekit";
    rev = "refs/tags/${version}";
    hash = "sha256-F3PhZsuIgT3x1Y3/kx9juPwN2WKxvdbahrRm+r6ZPps=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_ip_pairing.py"
  ];

  disabledTests = [
    # AttributeError: 'MockedAsyncServiceInfo' object has no attribute '_set_properties'
    "test_discover_find_one_unpaired"
    "test_find_device_id_case_lower"
    "test_find_device_id_case_upper"
    "test_discover_missing_csharp"
    "test_discover_csharp_case"
    "test_discover_device_id_case_lower"
    "test_discover_device_id_case_upper"
  ];

  pythonImportsCheck = [ "aiohomekit" ];

  meta = with lib; {
    description = "Python module that implements the HomeKit protocol";
    mainProgram = "aiohomekitctl";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    changelog = "https://github.com/Jc2k/aiohomekit/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
