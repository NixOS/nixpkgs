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

buildPythonPackage (finalAttrs: {
  pname = "gmqtt";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S3YbuVn3fC7Gjt8rLJ0ET19kzWzVvmW0AgajnZ4m53Q=";
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
})
