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
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThyMYthOS";
    repo = "python-stiebel-eltron";
    tag = "v${version}";
    hash = "sha256-irZmtsGcbmr5+aniBofDg0fhkP646h3mpRyTdWndOyY=";
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
