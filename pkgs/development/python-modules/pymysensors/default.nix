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
  version = "0.21.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "theolind";
    repo = pname;
    rev = version;
    sha256 = "1k75gwvyzslyjr3cdx8b74fb302k2i7bda4q92rb75rhgp4gch55";
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

  pythonImportsCheck = [ "mysensors" ];

  meta = with lib; {
    description = "Python API for talking to a MySensors gateway";
    homepage = "https://github.com/theolind/pymysensors";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
