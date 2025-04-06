{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  cachetools,
  defusedxml,
  docker,
  fetchFromGitHub,
  pkg-config,
  pycountry,
  pytest-asyncio,
  pytest-codspeed,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  testfixtures,
  xz,
}:

buildPythonPackage rec {
  pname = "deebot-client";
  version = "12.5.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "DeebotUniverse";
    repo = "client.py";
    tag = version;
    hash = "sha256-+Tc4YZucd1P7g2jD2iQzYurQ7hjcUQyst8SUgXTtUsg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dxq/3TYqMm4ckE0En3iskt0OL71XN0bc9VsFUuaefp8=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "defusedxml"
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ xz ];

  dependencies = [
    aiohttp
    aiomqtt
    cachetools
    defusedxml
  ];

  nativeCheckInputs = [
    docker
    pycountry
    pytest-asyncio
    pytest-codspeed
    pytestCheckHook
    testfixtures
  ];

  preCheck = ''
    rm -rf deebot_client
  '';

  pythonImportsCheck = [ "deebot_client" ];

  disabledTests = [
    # Tests require running container
    "test_last_message_received_at"
    "test_client_bot_subscription"
    "test_client_reconnect_manual"
    "test_p2p_success"
    "test_p2p_not_supported"
    "test_p2p_data_type_not_supported"
    "test_p2p_to_late"
    "test_p2p_parse_error"
    "test_mqtt_task_exceptions"
    "test_mqtt_task_exceptions"
    "test_client_reconnect_on_broker_error"
  ];

  meta = with lib; {
    description = "Deebot client library";
    homepage = "https://github.com/DeebotUniverse/client.py";
    changelog = "https://github.com/DeebotUniverse/client.py/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
