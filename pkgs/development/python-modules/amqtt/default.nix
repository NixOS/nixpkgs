{
  lib,
  aiohttp,
  aiosqlite,
  argon2-cffi,
  buildPythonPackage,
  cacert,
  dacite,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  hypothesis,
  jsonschema,
  mergedeep,
  paho-mqtt,
  passlib,
  psutil,
  pyhamcrest,
  pyjwt,
  pyopenssl,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-logdog,
  pytestCheckHook,
  python-ldap,
  pyyaml,
  setuptools,
  sqlalchemy,
  transitions,
  typer,
  uv-dynamic-versioning,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "amqtt";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yakifo";
    repo = "amqtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J2BWaUJacsCDa3N9fNohn0l+5Vl4+g8Y8aWetjCfZ/A=";
  };

  pythonRelaxDeps = true;

  build-system = [
    hatch-vcs
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    dacite
    passlib
    psutil
    pyyaml
    setuptools
    transitions
    typer
    websockets
  ];

  nativeCheckInputs = [
    aiohttp
    aiosqlite
    argon2-cffi
    cacert
    hypothesis
    jsonschema
    mergedeep
    paho-mqtt
    pyhamcrest
    pyjwt
    pyopenssl
    pytest-asyncio
    pytest-cov-stub
    pytest-logdog
    pytestCheckHook
    python-ldap
    sqlalchemy
  ];

  disabledTests = [
    # Issue with the certificates
    "test_device_cert"
    "test_cli_mgr_no_params"
    "test_client_publish_ssl"
    "test_start_stop"
    "test_client_connect"
    "test_client_connect_will_flag"
    "test_client_connect_clean_session_false"
    "test_client_subscribe"
    "test_client_subscribe_twice"
    "test_client_unsubscribe"
    "test_client_publish"
    "test_client_publish_dup"
    "test_client_publishing_invalid_topic"
    "test_client_publish_asterisk"
    "test_client_publish_big"
    "test_client_publish_retain"
    "test_client_publish_retain_delete"
    "test_client_subscribe_publish"
    "test_client_subscribe_invalid"
    "test_client_subscribe_publish_dollar_topic_1"
    "test_client_subscribe_publish_dollar_topic_2"
    "test_client_publish_clean_session_subscribe"
    "test_client_publish_retain_with_new_subscribe"
    "test_client_publish_retain_latest_with_new_subscribe"
    "test_client_publish_retain_subscribe_on_reconnect"
    "test_matches_multi_level_wildcard"
    "test_matches_single_level_wildcard"
    "test_broker_broadcast_cancellation"
    "test_broker_socket_open_close"
    "test_connect_tcp"
    "test_connect_tcp_secure"
    "test_connect_ws"
    "test_reconnect_ws_retain_username_password"
    "test_connect_ws_secure"
    "test_connect_username_without_password"
    "test_ping"
    "test_subscribe"
    "test_unsubscribe"
    "test_deliver"
    "test_deliver_timeout"
    "test_cancel_publish_qos1"
    "test_cancel_publish_qos2_pubrec"
    "test_cancel_publish_qos2_pubcomp"
    "test_client_will_with_clean_disconnect"
    "test_client_will_with_abrupt_disconnect"
    "test_client_retained_will_with_abrupt_disconnect"
    "test_client_abruptly_disconnecting_with_empty_will_message"
    "test_publish_to_incorrect_wildcard"
    "test_paho_connect"
    "test_paho_qos1"
    "test_paho_qos2"
  ];

  preCheck = ''
    # Some tests need amqtt
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "amqtt" ];

  meta = {
    description = "Python MQTT client and broker implementation";
    homepage = "https://amqtt.readthedocs.io/";
    changelog = "https://github.com/Yakifo/amqtt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
