{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "gmqtt";
  version = "0.6.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3dH9wcauYE50N3z3DpnwZ+V5wDwccaas1JThmek7f6Q=";
  };

  build-system = [ setuptools ];

  # Tests require local socket connection which is forbidden in the sandbox
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];
  pythonImportsCheck = [ "gmqtt" ];

  meta = {
    description = "Python MQTT v5.0 async client";
    homepage = "https://github.com/wialon/gmqtt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
