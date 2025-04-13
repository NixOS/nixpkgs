{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mpi,
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
    mpiCheckPhaseHook
  ];

  doCheck = true;

  # follow the upstream check process in ci-test.yml
  checkPhase = ''
    runHook preCheck

    for nproc in {1..2}; do
      echo "Testing mpi4py (np=$nproc)"
      mpiexec -n $nproc python test/main.py
      echo "Testing mpi4py.futures (np=$nproc)"
      mpiexec -n $nproc python demo/futures/test_futures.py
    done

    echo "Testing mpi4py.run"
    python demo/test-run/test_run.py
    echo "Testing init-fini"
    bash demo/init-fini/run.sh

    runHook postCheck
  '';

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
