{
  lib,
  buildPythonPackage,
  fetchPypi,
  gtfs-realtime-bindings,
  httpx,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytransportnswv2";
  version = "2.0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "PyTransportNSWv2";
    inherit version;
    hash = "sha256-+hE5onXQ/Isv+U7y9+CphpYTOW7CsMxR7M8jZS1djSs=";
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
