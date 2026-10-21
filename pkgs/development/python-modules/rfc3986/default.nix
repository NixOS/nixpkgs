{
  lib,
  buildPythonPackage,
  fetchPypi,
  idna,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l6rPnb1L/YKbqtbmMJ+mVzqvG+P2+nNcirBeRs7LJhw=";
  };

  propagatedBuildInputs = [ idna ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rfc3986" ];

  meta = {
    description = "Validating URI References per RFC 3986";
    homepage = "https://rfc3986.readthedocs.org";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
