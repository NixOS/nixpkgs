{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
}:

buildPythonPackage rec {
  version = "2021.11.0";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "602d2e2d7816a4abc1eb17998e1acc93a43b6f82bf94a6accca169a42de21898";
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
