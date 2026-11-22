{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scipy,
  sympy,
  checkpoint-schedules,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyadjoint-ad";
  version = "2026.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfin-adjoint";
    repo = "pyadjoint";
    tag = finalAttrs.version;
    hash = "sha256-1tJ4iWjtd26UU4mMeAeYqytRddTay0pB/KJ6RfvlXd0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    scipy
    sympy
    checkpoint-schedules
  ];

  pythonImportsCheck = [
    "numpy_adjoint"
    "pyadjoint"
    "pyadjoint.optimization"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "tests/pyadjoint"
  ];

  meta = {
    homepage = "https://github.com/dolfin-adjoint/pyadjoint";
    description = "High-level automatic differentiation library";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
