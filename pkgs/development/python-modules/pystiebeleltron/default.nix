{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pymodbus,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pystiebeleltron";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThyMYthOS";
    repo = "python-stiebel-eltron";
    tag = "v${version}";
    hash = "sha256-vJo9fjtbGuWJ1JcK6u0Cnol1Ev3eobD14YjH+S256og=";
  };

  build-system = [ hatchling ];

  dependencies = [ pymodbus ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "pystiebeleltron" ];

  meta = {
    description = "Python API for interacting with the Stiebel Eltron ISG web gateway via Modbus";
    homepage = "https://github.com/ThyMYthOS/python-stiebel-eltron";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
