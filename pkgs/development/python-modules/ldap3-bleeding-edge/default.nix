{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  gssapi,
  pyasn1,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ldap3-bleeding-edge";
  version = "2.10.1.1337";
  pyproject = true;

  src = fetchPypi {
    pname = "ldap3_bleeding_edge";
    inherit version;
    hash = "sha256-j4hzcqwOONol6YqY9Ldz9YphjPmacFoVyqUnMHW1aZk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    gssapi
    pyasn1
    pycryptodomex
  ];

  pythonImportsCheck = [ "ldap3" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Strictly RFC 4510 conforming LDAP V3 client library (bleeding edge)";
    homepage = "https://pypi.org/project/ldap3-bleeding-edge/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
