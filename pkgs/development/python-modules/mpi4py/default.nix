{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mpi,
  toPythonModule,
  pytestCheckHook,
  mpiCheckPhaseHook,
}:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mpi4py";
    owner = "mpi4py";
    tag = version;
    hash = "sha256-Hm+x79utOrjAbprud2MECgakyOzgShSwNuoyZUcTluQ=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    mpi
  ];

  dependencies = [
    # Use toPythonModule so that also the mpi executables will be propagated to
    # generated Python environment.
    (toPythonModule mpi)
  ];

  pythonImportsCheck = [ "mpi4py" ];

  nativeCheckInputs = [
    pytestCheckHook
    mpiCheckPhaseHook
  ];
  disabledTestPaths = lib.optionals (mpi.pname == "mpich") [
    # These tests from some reason cause pytest to crash, and therefor it is
    # hard to debug them. Upstream mentions these tests to raise issues in
    # https://github.com/mpi4py/mpi4py/issues/418  but the workaround suggested
    # there (setting MPI4PY_RC_RECV_MPROBE=0) doesn't work.
    "test/test_util_pool.py"
    "demo/futures/test_futures.py"
  ];

  __darwinAllowLocalNetworking = true;

  # skip spawn related tests for openmpi implemention
  # see https://github.com/mpi4py/mpi4py/issues/545#issuecomment-2343011460
  env.MPI4PY_TEST_SPAWN = if mpi.pname == "openmpi" then 0 else 1;

  passthru = {
    inherit mpi;
  };

  meta = {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    changelog = "https://github.com/mpi4py/mpi4py/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
