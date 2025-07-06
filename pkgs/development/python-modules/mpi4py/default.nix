{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mpi,
  toPythonModule,
  mpiCheckPhaseHook,
  mpich,
  mpi4py,
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
    mpiCheckPhaseHook
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  # follow the upstream check process in https://github.com/mpi4py/mpi4py/blob/4.0.3/.github/workflows/ci-test.yml
  checkPhase = ''
    runHook preCheck

    for nproc in {1..2}; do
      echo "Testing mpi4py (np=$nproc)"
      mpiexec -n $nproc python test/main.py -v
      echo "Testing mpi4py.futures (np=$nproc)"
      mpiexec -n $nproc python demo/futures/test_futures.py -v
    done

    runHook postCheck
  '';

  passthru = {
    inherit mpi;
    tests.mpich = mpi4py.override { mpi = mpich; };
  };

  meta = {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    changelog = "https://github.com/mpi4py/mpi4py/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
