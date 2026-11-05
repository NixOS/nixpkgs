{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  modbus-connection,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "pystiebeleltron";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThyMYthOS";
    repo = "python-stiebel-eltron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9g/ZM3h9ivySAYwDgbswwkIYXeG44IhOvgJyLnwdKps=";
  };

  build-system = [ hatchling ];

  dependencies = [
    modbus-connection
  ]
  ++ modbus-connection.optional-dependencies.tmodbus;

  nativeCheckInputs = [
    jinja2
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
