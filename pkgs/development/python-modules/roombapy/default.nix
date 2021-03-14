{ buildPythonPackage
, fetchFromGitHub
, hbmqtt
, lib
, paho-mqtt
, poetry
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "1.6.2-1";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    rev = version;
    sha256 = "14k7bys479xwpa4alpdwphzmxm3x8kc48nfqnshn1wj94vyxc425";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ paho-mqtt ];

  checkInputs = [ hbmqtt pytest-asyncio pytestCheckHook ];
  pytestFlagsArray = [ "tests/" "--ignore=tests/test_discovery.py" ];
  pythonImportsCheck = [ "roombapy" ];

  meta = with lib; {
    homepage = "https://github.com/pschmitt/roombapy";
    description = "Python program and library to control Wi-Fi enabled iRobot Roombas";
    maintainers = with maintainers; [ justinas ];
    license = licenses.mit;
  };
}
