{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mpi,
  toPythonModule,
  pytest,
  mpiCheckPhaseHook,
  mpi4py,
  mpich,
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
    pytest
    mpiCheckPhaseHook
  ];

  __darwinAllowLocalNetworking = true;

  # skip spawn related tests for openmpi implemention
  # see https://github.com/mpi4py/mpi4py/issues/545#issuecomment-2343011460
  env.MPI4PY_TEST_SPAWN = if mpi.pname == "openmpi" then 0 else 1;

  # follow upstream's checkPhase
  # see https://github.com/mpi4py/mpi4py/blob/4.1.0/.github/workflows/ci-test.yml#L92-L95
  checkPhase = ''
    runHook preCheck

    echo 'Testing mpi4py (np=1)'
    mpiexec -n 1 python test/main.py -v
    echo 'Testing mpi4py (np=2)'
    mpiexec -n 2 python test/main.py -v -f -e spawn

    runHook postCheck
  '';

  passthru = {
    inherit mpi;

    tests = {
      mpich = mpi4py.override { mpi = mpich; };
    };
  };

  meta = {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://github.com/mpi4py/mpi4py";
    changelog = "https://github.com/mpi4py/mpi4py/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
