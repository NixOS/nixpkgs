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
  version = "2025.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dolfin-adjoint";
    repo = "pyadjoint";
    tag = version;
    hash = "sha256-caW2X4q0mHnD8CEh5jjelD4xBth/R/8/P3m0tTeO/LQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    scipy
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
}
