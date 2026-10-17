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

buildPythonPackage (finalAttrs: {
  pname = "pystiebeleltron";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThyMYthOS";
    repo = "python-stiebel-eltron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Sj3qh8tNw7xoSdK6B8ooDgM52HZ2uN1AcXrEXyKvRE=";
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
    changelog = "https://github.com/ThyMYthOS/python-stiebel-eltron/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
