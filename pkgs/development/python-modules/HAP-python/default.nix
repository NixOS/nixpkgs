{ lib
, buildPythonPackage
, base36
, cryptography
, curve25519-donna
, ecdsa
, ed25519
, fetchFromGitHub
, h11
, pyqrcode
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "HAP-python";
  version = "3.4.1";
  disabled = pythonOlder "3.5";

  # pypi package does not include tests
  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tZ6Zwlx5J62Xqpxxmt8Phdd9ngtKYhP/p3uor1dRfK8=";
  };

  propagatedBuildInputs = [
    base36
    cryptography
    curve25519-donna
    ecdsa
    ed25519
    h11
    pyqrcode
    zeroconf
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  # Disable tests requiring network access
  disabledTestPaths = [
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
  ];

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
