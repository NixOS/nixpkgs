{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  dask,
  distributed,
  mpi4py,
}:

buildPythonPackage rec {
  pname = "dask-mpi";
  version = "2025.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YxQOdPrILlB5jlfn/b3SVKUTg87lyjeqazRbGHF1g8A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dask
    distributed
    mpi4py
  ];

  # Hardcoded mpirun path in tests
  doCheck = false;

  pythonImportsCheck = [ "dask_mpi" ];

  meta = {
    description = "Deploy Dask using mpi4py";
    mainProgram = "dask-mpi";
    homepage = "https://github.com/dask/dask-mpi";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
