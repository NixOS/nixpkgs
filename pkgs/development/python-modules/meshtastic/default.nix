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
, pytestCheckHook
, pythonOlder
, pyyaml
, tabulate
, pytap2
, timeago
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "Meshtastic-python";
    rev = "refs/tags/${version}";
    hash = "sha256-2m63OSVyhZgptBln+b65zX3609Liwq5V2a78UQThHyE=";
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
    tabulate
    timeago
  ];

  passthru.optional-dependencies = {
    tunnel = [
      pytap2
    ];
  };

  checkInputs = [
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
    "test_setURL_empty_url"
    "test_watchGPIOs"
    "test_writeConfig_with_no_radioConfig"
    "test_writeGPIOs"
  ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://github.com/meshtastic/Meshtastic-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
