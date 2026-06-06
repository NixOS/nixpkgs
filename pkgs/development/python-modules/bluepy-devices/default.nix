{
  lib,
  bluepy,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bluepy-devices";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "bluepy_devices";
    inherit version;
    sha256 = "02zzzivxq2vifgs65m2rm8pqlsbzsbc419c032irzvfxjx539mr8";
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
}
