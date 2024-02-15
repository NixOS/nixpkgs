{ lib
, aiohttp
, aiomqtt
, buildPythonPackage
, cachetools
, defusedxml
, docker
, fetchFromGitHub
, numpy
, pillow
, pycountry
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, svg-py
, testfixtures
}:

buildPythonPackage rec {
  pname = "deebot-client";
  version = "5.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "DeebotUniverse";
    repo = "client.py";
    rev = "refs/tags/${version}";
    hash = "sha256-axz31GboqaWAcBU8DtG700Se6rX7VV7eBrQBDazG+Ig=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    aiomqtt
    cachetools
    defusedxml
    numpy
    pillow
    svg-py
  ];

  nativeCheckInputs = [
    docker
    pycountry
    pytest-asyncio
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [
    "deebot_client"
  ];

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
