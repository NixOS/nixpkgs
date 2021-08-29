{ lib
, aenum
, aiohttp
, aiohttp-wsgi
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pytest-aiohttp
, pytest-asyncio
, requests
, websocket_client
, websockets
}:

buildPythonPackage rec {
  pname = "homematicip";
  version = "1.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "coreGreenberet";
    repo = "homematicip-rest-api";
    rev = version;
    sha256 = "0bgvrjcf10kiqqkbl56sxx3jydd722b08q2j9c8sxpk0qdrmrinv";
  };

  propagatedBuildInputs = [
    aenum
    aiohttp
    async-timeout
    requests
    websocket_client
    websockets
  ];

  checkInputs = [
    aiohttp-wsgi
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Assert issues with datetime
    "test_contact_interface_device"
    "test_dimmer"
    "test_heating_failure_alert_group"
    "test_heating"
    "test_humidity_warning_rule_group"
    "test_meta_group"
    "test_pluggable_switch_measuring"
    "test_rotary_handle_sensor"
    "test_security_group"
    "test_shutter_device"
    "test_smoke_detector"
    "test_switching_group"
    "test_temperature_humidity_sensor_outdoor"
    "test_wall_mounted_thermostat_pro"
    "test_weather_sensor"
    # Random failures
    "test_home_getSecurityJournal"
    "test_home_unknown_types"
    # Requires network access
    "test_websocket"
  ];

  pythonImportsCheck = [ "homematicip" ];

  meta = with lib; {
    description = "Python module for the homematicIP REST API";
    homepage = "https://github.com/coreGreenberet/homematicip-rest-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
