{ lib
, buildPythonPackage
, base36
, chacha20poly1305-reuseable
, cryptography
, fetchFromGitHub
, h11
, orjson
, pyqrcode
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "hap-python";
  version = "4.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = "HAP-python";
    rev = "refs/tags/${version}";
    hash = "sha256-fAJB1gk8zTS/mW5KzWr3z26qctZc/EQlk//WM1Xwpl0=";
  };

  propagatedBuildInputs = [
    chacha20poly1305-reuseable
    cryptography
    h11
    orjson
    zeroconf
  ];

  passthru.optional-dependencies.QRCode = [
    base36
    pyqrcode
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.QRCode;

  disabledTestPaths = [
    # Disable tests requiring network access
    "tests/test_accessory_driver.py"
    "tests/test_hap_handler.py"
    "tests/test_hap_protocol.py"
  ];

  disabledTests = [
    "test_persist_and_load"
    "test_we_can_connect"
    "test_idle_connection_cleanup"
    "test_we_can_start_stop"
    "test_push_event"
    "test_bridge_run_stop"
    "test_migration_to_include_client_properties"
  ];

  pythonImportsCheck = [
    "pyhap"
  ];

  meta = with lib; {
    description = "HomeKit Accessory Protocol implementation";
    homepage = "https://github.com/ikalchev/HAP-python";
    changelog = "https://github.com/ikalchev/HAP-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
