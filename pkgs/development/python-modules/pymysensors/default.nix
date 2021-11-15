{ lib
, buildPythonPackage
, click
, crcmod
, fetchFromGitHub
, getmac
, intelhex
, paho-mqtt
, pyserial
, pyserial-asyncio
, pytest-sugar
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "pymysensors";
  version = "0.22.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "theolind";
    repo = pname;
    rev = version;
    sha256 = "sha256-tDetHSpA5ZRvJoThI1zY6NPiDJHfWZbiMM5AF+xCNgk=";
  };

  propagatedBuildInputs = [
    click
    crcmod
    getmac
    intelhex
    paho-mqtt
    pyserial
    pyserial-asyncio
    voluptuous
  ];

  checkInputs = [
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mysensors"
  ];

  meta = with lib; {
    description = "Python API for talking to a MySensors gateway";
    homepage = "https://github.com/theolind/pymysensors";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
