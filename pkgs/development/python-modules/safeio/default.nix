{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "safeio";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "safeIO";
    inherit version;
    hash = "sha256-1ICm2rAaOQ68JMEta3dK0AzvPbU0itB9i9EdJyqAjNM=";
  };

  pythonImportsCheck = [ "safeIO" ];

  meta = with lib; {
    description = "Safely make I/O operations to files in Python even from multiple threads";
    homepage = "https://github.com/Animenosekai/safeIO";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
