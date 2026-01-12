{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bleak,
}:

buildPythonPackage rec {
  pname = "pycycling";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7vOjkXZ/IrsJ9JyqkbaeNcB59ZyfHQJLit5yPHoBUH4=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    bleak
  ];

  pythonImportsCheck = [ pname ];

  meta = {
    description = "Package for interacting with Bluetooth Low Energy (BLE) compatible bike trainers, power meters, radars and heart rate monitors";
    homepage = "https://github.com/zacharyedwardbull/pycycling";
    changelog = "https://github.com/zacharyedwardbull/pycycling/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
  };
}
