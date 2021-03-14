{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
}:

buildPythonPackage rec {
  version = "2.21.0";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e153fc8c58047d898970b33ede0ab1990bd4e69cc130c6627a96f11b12a1a7";
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
