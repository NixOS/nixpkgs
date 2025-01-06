{
  lib,
  buildPythonPackage,
  fetchPypi,
  gtfs-realtime-bindings,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytransportnswv2";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyTransportNSWv2";
    inherit version;
    hash = "sha256-hpbq1Krv+DklSXBMJsyRZd8d0yj+vaRjlu2pu6sLV0Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gtfs-realtime-bindings
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSWv2" ];

  meta = with lib; {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
