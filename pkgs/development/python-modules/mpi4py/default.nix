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
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mpi4py";
    owner = "mpi4py";
    rev = version;
    hash = "sha256-pH4z+hyoFOSAUlXv9EKO54/SM5HyLxv7B+18xBidH2Q=";
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
  disabledTestPaths = [
    # Almost all tests in this file fail (TODO: Report about this upstream..)
    "test/test_spawn.py"
  ];

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
