{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  hatchling,
  hatch-vcs,
  toolz,
}:

buildPythonPackage rec {
  pname = "in-n-out";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "in_n_out";
    inherit version;
    hash = "sha256-Q83it96YHUGm1wYYore9mJSBCVkipT6tTcdfK71d/+o=";
  };

  build-system = [
    cython
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
    toolz
  ];

  pythonImportsCheck = [ "in_n_out" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [
    # Fatal Python error
    "tests/test_injection.py"
    "tests/test_processors.py"
    "tests/test_providers.py"
    "tests/test_store.py"
  ];

  meta = {
    description = "Module for dependency injection and result processing";
    homepage = "https://github.com/pyapp-kit/in-n-out";
    changelog = "https://github.com/pyapp-kit/in-n-out/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
