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
  version = "0.20.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = "refs/tags/${version}";
    hash = "sha256-GNjyDkqhOP9sq2qoAZCdSrUNte3FynVxhy9RSUn9j/c=";
  };

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # mismatch in expected data structure
    "test_parse_advertisement_data_curtain"
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
