{
  lib,
  buildPythonPackage,
  roboticstoolbox-python,
  pybullet,
  quadprog,
  qpsolvers,
  setuptools,
  sympy,
  pytestCheckHook,
  pythonAtLeast,
}:
buildPythonPackage {
  pname = "roboticstoolbox-python-tests";
  inherit (roboticstoolbox-python) version;

  src = roboticstoolbox-python.testsout;

  format = "other";
  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytestCheckHook
    roboticstoolbox-python
    pybullet
    quadprog
    qpsolvers
    setuptools
    sympy
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    # does not work on 3.12 as it requires distutils which was removed
    "tests/test_CustomXacro.py"
  ];
}
