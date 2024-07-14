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
    hash = "sha256-KNc0Spfd7Z+jGIClQNjSf2mKL6pZ1GL0c3EL3Hf8/ws=";
  };

  propagatedBuildInputs = [ bluepy ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "bluepy_devices" ];

  meta = with lib; {
    description = "Python BTLE Device Interface for bluepy";
    homepage = "https://github.com/bimbar/bluepy_devices";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
