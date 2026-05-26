{
  lib,
  bluepy,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "bluepy-devices";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "bluepy_devices";
    inherit version;
    sha256 = "02zzzivxq2vifgs65m2rm8pqlsbzsbc419c032irzvfxjx539mr8";
  };

  propagatedBuildInputs = [ bluepy ];

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
