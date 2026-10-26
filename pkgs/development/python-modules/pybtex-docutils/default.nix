{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  pybtex,
  pytestCheckHook,
  setuptools_80,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybtex-docutils";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-On69+StZPgDowcU4qpogvKXZLYQjESRxWsyWTVHZPGs=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [
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
})
