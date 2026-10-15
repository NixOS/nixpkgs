{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  mypy,
  pytestCheckHook,
  python-lsp-server,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylsp-mypy";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pylsp_mypy";
    inherit (finalAttrs) version;
    hash = "sha256-ANhur6TlRO6Bpzl57/GpmPvUDUrpwYIf6IAjMmp1bcI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mypy
    python-lsp-server
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsp_mypy" ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://pypi.org/project/pylsp-mypy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
