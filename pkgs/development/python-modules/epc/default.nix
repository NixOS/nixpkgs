{
  lib,
  buildPythonPackage,
  fetchPypi,
  sexpdata,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "epc";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oU0up0gXlVog6wCBLjpGMKEyiX602XZCAkDxFSwNfSU=";
  };

  build-system = [ setuptools ];

  dependencies = [ sexpdata ];

  pythonImportsCheck = [ "epc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # imports nose
    "epc/tests/test_py2py.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "EPC (RPC stack for Emacs Lisp) implementation in Python";
    homepage = "https://github.com/tkf/python-epc";
    license = lib.licenses.gpl3Only;
  };
})
