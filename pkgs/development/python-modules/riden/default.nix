{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  modbus-tk,
  poetry-core,
  pyserial,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "riden";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geeksville";
    repo = "riden";
    tag = version;
    hash = "sha256-uR1CsVsGn/QC4krHaxl6GqRnTPbFdRaqyMEl2RVMHPU=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    click
    modbus-tk
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "riden" ];

  meta = with lib; {
    description = "Module for Riden RD power supplies";
    homepage = "https://github.com/geeksville/riden";
    changelog = "https://github.com/geeksville/Riden/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
