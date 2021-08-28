{ lib
, amqtt
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.6.3";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    rev = version;
    sha256 = "sha256-GkDfIC2jx4Mpguk/Wu45pZw0czhabJwTz58WYSLCOV8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ paho-mqtt ];

  checkInputs = [
    amqtt
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_discovery.py"
  ];

  pythonImportsCheck = [ "roombapy" ];

  meta = with lib; {
    homepage = "https://github.com/pschmitt/roombapy";
    description = "Python program and library to control Wi-Fi enabled iRobot Roombas";
    maintainers = with maintainers; [ justinas ];
    license = licenses.mit;
  };
}
