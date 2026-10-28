{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pytransportnsw";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyTransportNSW";
    inherit version;
    hash = "sha256-w4HQ4gxlIrGh2dS0/FZIfff4srCCYawiRIXVHOWjUwI=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/Dav0815/TransportNSW";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
