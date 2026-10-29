{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  replaceVars,
  graphviz,
  pytestCheckHook,
  chardet,
  parameterized,
  pyparsing,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydot";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-whSPaBxKM+CL8OJqnl+OQJmoLg4qBoCY8yzoZXc2StU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ pyparsing ];

  nativeCheckInputs = [
    chardet
    parameterized
    pytestCheckHook
  ];

  patches = [
    (replaceVars ./hardcode-graphviz-path.patch {
      inherit graphviz;
    })
  ];

  enabledTestPaths = [ "test/test_pydot.py" ];

  pythonImportsCheck = [ "pydot" ];

  meta = {
    description = "Allows to create both directed and non directed graphs from Python";
    homepage = "https://github.com/erocarrera/pydot";
    changelog = "https://github.com/pydot/pydot/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
