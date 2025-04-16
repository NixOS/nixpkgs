{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mpi,
  pytestCheckHook,
  mpiCheckPhaseHook,
}:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mpi4py";
    owner = "mpi4py";
    tag = version;
    hash = "sha256-eN/tjlnNla6RHYOXcprVVqtec1nwCEGn+MBcV/5mHJg=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    mpi
  ];

  dependencies = [
    mpi
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
