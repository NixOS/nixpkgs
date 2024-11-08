{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  hypothesis,
  passlib,
  poetry-core,
  pytest-logdog,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  setuptools,
  transitions,
  websockets,
}:

buildPythonPackage rec {
  pname = "amqtt";
  version = "unstable-2022-05-29";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yakifo";
    repo = pname;
    rev = "09ac98d39a711dcff0d8f22686916e1c2495144b";
    hash = "sha256-8T1XhBSOiArlUQbQ41LsUogDgOurLhf+M8mjIrrAC4s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'transitions = "^0.8.0"' 'transitions = "*"' \
      --replace 'websockets = ">=9.0,<11.0"' 'websockets = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    docopt
    passlib
    pyyaml
    setuptools
    transitions
    websockets
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-logdog
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # stuck in epoll
    "test_publish_qos0"
    "test_publish_qos1"
    "test_publish_qos1_retry"
    "test_publish_qos2"
    "test_publish_qos2_retry"
    "test_receive_qos0"
    "test_receive_qos1"
    "test_receive_qos2"
    "test_start_stop"
  ];

  disabledTestPaths = [
    # Test are not ported from hbmqtt yet
    "tests/test_client.py"
  ];

  preCheck = ''
    # Some tests need amqtt
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "amqtt" ];

  meta = with lib; {
    description = "Python MQTT client and broker implementation";
    homepage = "https://amqtt.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
