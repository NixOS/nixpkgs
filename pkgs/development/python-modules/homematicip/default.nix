{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "homematicip";
  version = "2.0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "hahn-th";
    repo = "homematicip-rest-api";
    tag = version;
    hash = "sha256-klDyrbIJeAm3C7sCo4Z4OKDvm5+V8mfwYbyS22CKVQU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    httpx
    requests
    websockets
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  disabledTests = [
    # Assert issues with datetime
    "test_contact_interface_device"
    "test_dimmer"
    "test_external_device"
    "test_heating_failure_alert_group"
    "test_heating"
    "test_humidity_warning_rule_group"
    "test_meta_group"
    "test_pluggable_switch_measuring"
    "test_rotary_handle_sensor"
    "test_security_group"
    "test_security_zone"
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
    description = "Module for the homematicIP REST API";
    homepage = "https://github.com/hahn-th/homematicip-rest-api";
    changelog = "https://github.com/hahn-th/homematicip-rest-api/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
