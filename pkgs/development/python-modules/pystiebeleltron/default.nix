{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  modbus-connection,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pystiebeleltron";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThyMYthOS";
    repo = "python-stiebel-eltron";
    tag = "v${version}";
    hash = "sha256-UWUSxdSuLDkYWHvgNbZ6TmXSMU8/sKa77I5JHHgTy0k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    modbus-connection
  ]
  ++ modbus-connection.optional-dependencies.pymodbus;

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
