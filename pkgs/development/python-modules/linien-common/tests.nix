{
  buildPythonPackage,
  cma,
  linien-client,
  linien-common,
  matplotlib,
  migen,
  misoc,
  pytest-plt,
  pytestCheckHook,
  tmpdirAsHomeHook,
}:

buildPythonPackage {
  pname = "linien-tests";
  inherit (linien-common) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    cma
    linien-client
    linien-common
    matplotlib
    migen
    misoc
    pytest-plt
    pytestCheckHook
    tmpdirAsHomeHook
  ];

  disabledTestPaths = [
    # require linien-server which is not packaged
    "tests/test_algorithm_selection.py"
    "tests/test_approacher.py"
    "tests/test_optimizer_engines.py"
    "tests/test_optimizer_utils.py"
    "tests/test_robust_autolock.py"
    "tests/test_simple_autolock_cpu.py"
  ];
}
