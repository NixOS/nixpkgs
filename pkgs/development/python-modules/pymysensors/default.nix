{
  lib,
  awesomeversion,
  buildPythonPackage,
  click,
  crcmod,
  fetchFromGitHub,
  getmac,
  intelhex,
  paho-mqtt,
  pyserial-asyncio-fast,
  pyserial,
  pytest-sugar,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pymysensors";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theolind";
    repo = "pymysensors";
    tag = version;
    hash = "sha256-iND3MEKEruqCdsqJJExm+SA4Z2e87I45fsI4wbnIPRc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    awesomeversion
    click
    crcmod
    getmac
    intelhex
    pyserial
    pyserial-asyncio-fast
    voluptuous
  ];

  optional-dependencies = {
    mqtt-client = [ paho-mqtt ];
  };

  nativeCheckInputs = [
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mysensors" ];

  meta = with lib; {
    description = "Python API for talking to a MySensors gateway";
    homepage = "https://github.com/theolind/pymysensors";
    changelog = "https://github.com/theolind/pymysensors/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pymysensors";
  };
}
