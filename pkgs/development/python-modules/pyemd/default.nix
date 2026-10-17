{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pot,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyemd";
  version = "2.0.0";
  pyproject = true;

  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FZaflENcK+mOajakkwfINm49/BpnASrMMG6SyQtQP+U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    pot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = "https://github.com/wmayner/pyemd";
    changelog = "https://github.com/wmayner/pyemd/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
