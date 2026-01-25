{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m1mislun5PgZfbdobAn7M+ZYuYM5+tuCbpUSYpAXgzs=";
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
