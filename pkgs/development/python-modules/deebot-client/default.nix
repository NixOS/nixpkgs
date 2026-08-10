{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  cachetools,
  cryptography,
  defusedxml,
  docker,
  fetchFromGitHub,
  orjson,
  pkg-config,
  pycountry,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-codspeed,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  syrupy,
  testfixtures,
  xz,
}:

buildPythonPackage (finalAttrs: {
  pname = "deebot-client";
  version = "18.5.1";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "DeebotUniverse";
    repo = "client.py";
    tag = finalAttrs.version;
    hash = "sha256-7edi2hTn4K+lJDKJbMmu4JY86fhmSUcRvxr1ZzaurSU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-j70hY9MskVKrfWYtQKj13LVdC8WbHdPe9w/88BWPvlM=";
  };

  nativeBuildInputs = [
    pkg-config
    pyprojectVersionPatchHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ xz ];

  dependencies = [
    aiohttp
    aiomqtt
    cachetools
    cryptography
    defusedxml
    orjson
  ];

  nativeCheckInputs = [
    docker
    pycountry
    pytest-asyncio
    pytest-codspeed
    pytestCheckHook
    syrupy
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

  meta = {
    description = "Deebot client library";
    homepage = "https://github.com/DeebotUniverse/client.py";
    changelog = "https://github.com/DeebotUniverse/client.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
