{
  lib,
  buildPythonPackage,
  fetchPypi,
  gtfs-realtime-bindings,
  httpx,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytransportnswv2";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyTransportNSWv2";
    inherit version;
    hash = "sha256-tFQnCGYgekXFrDXDpH8MZNlL1v9xeumMHmQvU6bwVZc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gtfs-realtime-bindings
    httpx
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
