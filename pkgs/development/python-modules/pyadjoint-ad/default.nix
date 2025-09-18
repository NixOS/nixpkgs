{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scipy,
  checkpoint-schedules,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyadjoint-ad";
  version = "2025.04.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfin-adjoint";
    repo = "pyadjoint";
    tag = version;
    hash = "sha256-S9A0qCatnnLuOkqWsEC4tjVY1HZqqi2T5iXu+WUoN24=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    scipy
    checkpoint-schedules
  ];

  pythonImportsCheck = [
    # The firedrake_adjoint module is deprecated and requires a cyclic dependency of firedrake
    # "firedrake_adjoint"
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
}
