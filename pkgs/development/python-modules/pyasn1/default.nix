{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OjWrLEte+Y4X397IqwdARvvaduKBxacGzNgjKM/I9kw=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = with lib; {
    description = "Generic ASN.1 library for Python";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/etingof/pyasn1/blob/master/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
