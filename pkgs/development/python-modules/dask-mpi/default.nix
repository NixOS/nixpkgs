{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
, pythonOlder
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

  propagatedBuildInputs = [
    dask
    distributed
    mpi4py
  ];

  # Hardcoded mpirun path in tests
  doCheck = false;

  pythonImportsCheck = [
    "dask_mpi"
  ];

  meta = with lib; {
    description = "Deploy Dask using mpi4py";
    homepage = "https://github.com/dask/dask-mpi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
