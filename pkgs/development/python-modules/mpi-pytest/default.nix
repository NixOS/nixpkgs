{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mpi4py,
  pytest,
  pytestCheckHook,
  mpiCheckPhaseHook,
}:

buildPythonPackage rec {
  pname = "mpi-pytest";
  version = "2025.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "mpi-pytest";
    tag = "v${version}";
    hash = "sha256-TZj1hObMVzYfAUC0UjXMvUThbKCNdiB1FMSA0AHjZ9s=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mpi4py
    pytest
  ];

  pythonImportsCheck = [
    "pytest_mpi"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mpiCheckPhaseHook
    mpi4py.mpi
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/firedrakeproject/mpi-pytest";
    description = "Pytest plugin that lets you run tests in parallel with MPI";
    changelog = "https://github.com/firedrakeproject/mpi-pytest/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
