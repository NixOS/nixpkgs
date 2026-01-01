{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  cachetools,
  defusedxml,
  docker,
  fetchFromGitHub,
  orjson,
  pkg-config,
  pycountry,
  pytest-asyncio,
  pytest-codspeed,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  syrupy,
  testfixtures,
  xz,
}:

buildPythonPackage rec {
  pname = "deebot-client";
<<<<<<< HEAD
  version = "17.0.0";
=======
  version = "16.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "DeebotUniverse";
    repo = "client.py";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-QreF2ivdPfu2KiYY4At3zpif8bx7d7AzbpXNgL3zXzE=";
=======
    hash = "sha256-R62z102kvdsZVdRcE0lBtwgynl3SECOXCoyaj0xXv2s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-n3lvezBP7oT9jLqPCFZ7hwdBGuSJYos+hob9HBX2zIY=";
=======
    hash = "sha256-ir3HZ3DiHcL34kGtyUwyKQZA6fiSj45eXBKL/71eqCs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [
    "aiohttp"
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

<<<<<<< HEAD
  meta = {
    description = "Deebot client library";
    homepage = "https://github.com/DeebotUniverse/client.py";
    changelog = "https://github.com/DeebotUniverse/client.py/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Deebot client library";
    homepage = "https://github.com/DeebotUniverse/client.py";
    changelog = "https://github.com/DeebotUniverse/client.py/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
