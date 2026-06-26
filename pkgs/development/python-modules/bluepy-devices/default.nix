{
  lib,
  bluepy,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluepy-devices";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "bluepy_devices";
    inherit (finalAttrs) version;
    hash = "sha256-KNc0Spfd7Z+jGIClQNjSf2mKL6pZ1GL0c3EL3Hf8/ws=";
  };

  build-system = [ setuptools ];

  dependencies = [ bluepy ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "bluepy_devices" ];

  meta = {
    description = "Python BTLE Device Interface for bluepy";
    homepage = "https://github.com/bimbar/bluepy_devices";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
