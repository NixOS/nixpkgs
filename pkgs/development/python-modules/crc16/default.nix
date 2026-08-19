{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crc16";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wfhqoDkPS68H0mMbFrl5WA6uHZqXOoJs5FNToi7o05Y=";
  };

  build-system = [ setuptools ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "crc16" ];

  meta = {
    description = "Python library for calculating CRC16";
    homepage = "https://code.google.com/archive/p/pycrc16/";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
