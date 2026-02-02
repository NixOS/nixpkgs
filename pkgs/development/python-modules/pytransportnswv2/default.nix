{
  lib,
  buildPythonPackage,
  fetchPypi,
  gtfs-realtime-bindings,
  httpx,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytransportnswv2";
  version = "2.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/dE1g+WG9aPDgi1qaCZ9YZTH89qW85P3ds8+iuh/8/M=";
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

  meta = {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
