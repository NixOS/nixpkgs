{
  lib,
  buildPythonPackage,
  fetchPypi,
  gtfs-realtime-bindings,
  hatchling,
  httpx,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytransportnswv2";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-U85dtE2mf0HQAACfVYnkzZjjA77kPhyZao3ved9+NqU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    gtfs-realtime-bindings
    httpx
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSWv2" ];

  meta = {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
