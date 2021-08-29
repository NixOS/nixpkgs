{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, hypothesis
, passlib
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pyyaml
, transitions
, websockets
}:

buildPythonPackage rec {
  pname = "amqtt";
  version = "0.10.0-alpha.3";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yakifo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wz85ykjgi2174qcdgpakmc4m0p96v62az7pvc9hyallq1v1k4n6";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    docopt
    passlib
    pyyaml
    transitions
    websockets
  ];

  checkInputs = [
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Test are not ported from hbmqtt yet
    "tests/test_cli.py"
    "tests/test_client.py"
  ];

  disabledTests = [
    # Requires network access
    "test_connect_tcp"
  ];

  pythonImportsCheck = [ "amqtt" ];

  meta = with lib; {
    description = "Python MQTT client and broker implementation";
    homepage = "https://amqtt.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
