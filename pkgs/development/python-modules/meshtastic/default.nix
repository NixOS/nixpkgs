{ lib
, buildPythonPackage
, dotmap
, fetchFromGitHub
, pexpect
, protobuf
, pygatt
, pypubsub
, pyqrcode
, pyserial
, pytap2
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, setuptools
, tabulate
, timeago
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "2.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "Meshtastic-python";
    rev = "refs/tags/${version}";
    hash = "sha256-JnheGeiLJMI0zsb+jiuMxjXg/3rDbMyA2XVtl1ujiso=";
  };

  propagatedBuildInputs = [
    dotmap
    pexpect
    protobuf
    pygatt
    pypubsub
    pyqrcode
    pyserial
    pyyaml
    setuptools
    requests
    tabulate
    timeago
  ];

  passthru.optional-dependencies = {
    tunnel = [
      pytap2
    ];
  };

  nativeCheckInputs = [
    pytap2
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "meshtastic"
  ];

  disabledTests = [
    # AttributeError: 'HardwareMessage'...
    "test_handleFromRadio_with_my_info"
    "test_handleFromRadio_with_node_info"
    "test_main_ch_longsfast_on_non_primary_channel"
    "test_main_ch_set_name_with_ch_index"
    "test_main_configure_with_camel_case_keys"
    "test_main_configure_with_snake_case"
    "test_main_export_config_called_from_main"
    "test_main_export_config_use_camel"
    "test_main_export_config"
    "test_main_get_with_invalid"
    "test_main_get_with_valid_values_camel"
    "test_main_getPref_invalid_field_camel"
    "test_main_getPref_invalid_field"
    "test_main_getPref_valid_field_bool_camel"
    "test_main_getPref_valid_field_bool"
    "test_main_getPref_valid_field_camel"
    "test_main_getPref_valid_field_string_camel"
    "test_main_getPref_valid_field_string"
    "test_main_getPref_valid_field"
    "test_main_set_invalid_wifi_passwd"
    "test_main_set_valid_camel_case"
    "test_main_set_valid_wifi_passwd"
    "test_main_set_valid"
    "test_main_set_with_invalid"
    "test_main_setPref_ignore_incoming_0"
    "test_main_setPref_ignore_incoming_123"
    "test_main_setPref_invalid_field_camel"
    "test_main_setPref_invalid_field"
    "test_main_setPref_valid_field_int_as_string"
    "test_readGPIOs"
    "test_onGPIOreceive"
    "test_setURL_empty_url"
    "test_watchGPIOs"
    "test_writeConfig_with_no_radioConfig"
    "test_writeGPIOs"
    "test_reboot"
    "test_shutdown"
    "test_main_sendtext"
    "test_main_sendtext_with_channel"
    "test_MeshInterface"
    "test_getNode_not_local"
    "test_getNode_not_local_timeout"
    "test_main_onConnected_exception"
  ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://github.com/meshtastic/Meshtastic-python";
    changelog = "https://github.com/meshtastic/python/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
