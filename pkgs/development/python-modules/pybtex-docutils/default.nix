{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  pybtex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pybtex-docutils";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-On69+StZPgDowcU4qpogvKXZLYQjESRxWsyWTVHZPGs=";
  };

  buildInputs = [
    docutils
    pybtex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybtex_docutils" ];

  meta = {
    description = "Docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = lib.licenses.mit;
  };
}
