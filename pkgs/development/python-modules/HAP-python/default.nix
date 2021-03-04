{ lib
, buildPythonPackage
, cryptography
, curve25519-donna
, ecdsa
, ed25519
, fetchFromGitHub
, h11
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "HAP-python";
  version = "3.3.2";
  disabled = pythonOlder "3.5";

  # pypi package does not include tests
  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oDTyFIhf7oogYyh9LpmVtagi1kDXLCc/7c2UH1dL2Sg=";
  };

  propagatedBuildInputs = [
    cryptography
    curve25519-donna
    ecdsa
    ed25519
    h11
    zeroconf
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests needing network
    "camera"
    "pair"
    "test_async_subscribe_client_topic"
    "test_auto_add_aid_mac"
    "test_connection_management"
    "test_crypto_failure_closes_connection"
    "test_empty_encrypted_data"
    "test_external_zeroconf"
    "test_get_accessories"
    "test_get_characteristics"
    "test_handle_set_handle_set"
    "test_handle_snapshot_encrypted_non_existant_accessory"
    "test_http_11_keep_alive"
    "test_http10_close"
    "test_mdns_service_info"
    "test_mixing_service_char_callbacks_partial_failure"
    "test_not_standalone_aid"
    "test_persist"
    "test_push_event"
    "test_send_events"
    "test_service_callbacks"
    "test_set_characteristics_with_crypto"
    "test_setup_endpoints"
    "test_start"
    "test_upgrade_to_encrypted"
    "test_we_can_start_stop"
    "test_xhm_uri"
  ];

  meta = with lib; {
    homepage = "https://github.com/ikalchev/HAP-python";
    description = "HomeKit Accessory Protocol implementation in python";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
