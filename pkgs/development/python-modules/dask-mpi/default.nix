{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
}:

buildPythonPackage rec {
  version = "2022.4.0";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CgTx19NaBs3/UGWTMw1EFOokLJFySYzhkfV0LqxJnhc=";
  };

  propagatedBuildInputs = [ dask distributed mpi4py ];

  # hardcoded mpirun path in tests
  doCheck = false;
  pythonImportsCheck = [ "dask_mpi" ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-mpi";
    description = "Deploy Dask using mpi4py";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
