{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-iotawattpy";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eMsBEbmENjbJME9Gzo4O9LbGo1i0MP0IuwLUAYqxbI8=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iotawattpy" ];

  meta = {
    description = "Python library for the IoTaWatt Energy device";
    homepage = "https://github.com/gtdiehl/iotawattpy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
