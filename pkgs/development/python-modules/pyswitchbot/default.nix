{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.18.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = "refs/tags/${version}";
    hash = "sha256-80GzOKZRsjWHLEGhNrYIWdUMiel5ztcobwRhrlyjzpY=";
  };

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "switchbot"
  ];

  meta = with lib; {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
