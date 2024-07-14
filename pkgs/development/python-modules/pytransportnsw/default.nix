{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pytransportnsw";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyTransportNSW";
    inherit version;
    hash = "sha256-w4HQ4gxlIrGh2dS0/FZIfff4srCCYawiRIXVHOWjUwI=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = with lib; {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/Dav0815/TransportNSW";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
