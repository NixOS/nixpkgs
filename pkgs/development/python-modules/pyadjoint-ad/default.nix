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
  version = "2026.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfin-adjoint";
    repo = "pyadjoint";
    tag = finalAttrs.version;
    hash = "sha256-YaIT4IN/gxoCY54NQ9WDJvFhG4D7CKl+CObRotGJ1nE=";
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
