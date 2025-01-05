{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  dask,
  distributed,
  mpi4py,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dask-mpi";
  version = "2022.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CgTx19NaBs3/UGWTMw1EFOokLJFySYzhkfV0LqxJnhc=";
  };

  patches = [
    # https://github.com/dask/dask-mpi/pull/123
    (fetchpatch {
      name = "fix-versioneer-on-python312.patch";
      url = "https://github.com/dask/dask-mpi/pull/123/commits/0f3b0286b7e29b5d5475561a148dc398108fc259.patch";
      hash = "sha256-xXADCSIhq1ARny2twzrhR1J8LkMFWFl6tmGxrM8RvkU=";
    })
  ];

  propagatedBuildInputs = [
    dask
    distributed
    mpi4py
  ];

  # Hardcoded mpirun path in tests
  doCheck = false;

  pythonImportsCheck = [ "dask_mpi" ];

  meta = with lib; {
    description = "Deploy Dask using mpi4py";
    mainProgram = "dask-mpi";
    homepage = "https://github.com/dask/dask-mpi";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
