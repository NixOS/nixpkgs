{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "curio-compat";
  version = "1.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "curio";
    rev = "refs/tags/${version}";
    hash = "sha256-Crd9r4Icwga85wvtXaePbE56R192o+FXU9Zn+Lc7trI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "curio" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # contacts google.com
    "test_ssl_outgoing"
  ];

  meta = {
    description = "Coroutine-based library for concurrent systems programming";
    homepage = "https://github.com/klen/curio";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
