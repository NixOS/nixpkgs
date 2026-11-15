{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  cryptography,
  httpx2,
  idna,
}:

buildPythonPackage rec {
  pname = "lacme";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FPWcjkt/QRS8fwVbd7FjToOl6xHnyZ/2zEiu2VP12Qw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    httpx2
    idna
  ];

  pythonImportsCheck = [ "lacme" ];

  meta = {
    description = "A lightweight ACME client for Python";
    homepage = "https://github.com/turnstonelabs/lacme";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
