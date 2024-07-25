{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bleak,
}:

buildPythonPackage rec {
  pname = "pycycling";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yi3ZcyhhOtHp46MK0R15/dic+b1oYjy4tFVRH3ssbE8=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    bleak
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Package for interacting with Bluetooth Low Energy (BLE) compatible bike trainers, power meters, radars and heart rate monitors";
    homepage = "https://github.com/zacharyedwardbull/pycycling";
    changelog = "https://github.com/zacharyedwardbull/pycycling/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
