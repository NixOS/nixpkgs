{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b1gNK92ENlOAgwrPRVUPJRFGn2c8tKWuOFejFwEosDQ=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = with lib; {
    description = "Generic ASN.1 library for Python";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/etingof/pyasn1/blob/master/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
