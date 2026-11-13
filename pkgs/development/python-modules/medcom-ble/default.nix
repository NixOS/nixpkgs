{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  bleak,
  bleak-retry-connector,
}:

buildPythonPackage rec {
  pname = "medcom-ble";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "medcom_ble";
    inherit version;
    hash = "sha256-PQ0ZOFLGVllz/Jxw2CN6D5Ypza5/Ck3dtk3DuB+eHiA=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [
    "medcom_ble"
  ];

  meta = {
    description = "Library to communicate with Medcom BLE radiation monitors";
    homepage = "https://github.com/elafargue/medcom-ble";
    changelog = "https://github.com/elafargue/medcom-ble/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
