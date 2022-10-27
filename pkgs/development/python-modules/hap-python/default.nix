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
  version = "4.5.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = "HAP-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/XJvCL9hMIrOUwGPcrvSrJ6SZ/E6BQy+isFFlAniIM4=";
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

  checkInputs = [
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

  pythonImportsCheck = [ "pyhap" ];

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
