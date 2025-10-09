{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "crc16";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wfhqoDkPS68H0mMbFrl5WA6uHZqXOoJs5FNToi7o05Y=";
  };

  build-system = [ setuptools ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "crc16" ];

  meta = with lib; {
    description = "Python library for calculating CRC16";
    homepage = "https://code.google.com/archive/p/pycrc16/";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
