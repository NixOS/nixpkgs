{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cython,
  setuptools,
  mpi,
  pytestCheckHook,
  mpiCheckPhaseHook,
}:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mpi4py";
    owner = "mpi4py";
    rev = version;
    hash = "sha256-hsP4aonjiBit2un6EQWQxF+lVjsnMFFqLaAOqBWAzgo=";
  };

  build-system = [
    cython
    setuptools
    mpi
  ];
  dependencies = [
    mpi
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    mpiCheckPhaseHook
  ];
  doCheck = true;

  passthru = {
    inherit mpi;
  };

  meta = {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
