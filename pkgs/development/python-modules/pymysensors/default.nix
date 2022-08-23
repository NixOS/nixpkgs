{ lib
, awesomeversion
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
  version = "0.24.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "theolind";
    repo = pname;
    rev = version;
    hash = "sha256-V6RZaS8c/PMcU/R8dxWd/m13VFnTBHn0VPpXeT7jOxc=";
  };

  propagatedBuildInputs = [
    awesomeversion
    click
    crcmod
    getmac
    intelhex
    pyserial
    pyserial-asyncio
    voluptuous
  ];

  passthru.optional-dependencies = {
    mqtt-client = [
      paho-mqtt
    ];
  };

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
