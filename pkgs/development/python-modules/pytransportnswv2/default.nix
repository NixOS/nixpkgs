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
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LbFBzC7kGa2qz+XQZDmjhE2FhmScesx5jtLtkV0hlg8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gtfs-realtime-bindings
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = with lib; {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
