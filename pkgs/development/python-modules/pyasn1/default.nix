{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b1gNK92ENlOAgwrPRVUPJRFGn2c8tKWuOFejFwEosDQ=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = {
    description = "Generic ASN.1 library for Python";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/etingof/pyasn1/blob/master/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
