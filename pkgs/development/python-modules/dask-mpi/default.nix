{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
, pytest
, requests
}:

buildPythonPackage rec {
  version = "2.21.0";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e153fc8c58047d898970b33ede0ab1990bd4e69cc130c6627a96f11b12a1a7";
  };

  checkInputs = [ pytest requests ];
  propagatedBuildInputs = [ dask distributed mpi4py ];

  checkPhase = ''
    py.test dask_mpi
  '';

  # hardcoded mpirun path in tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dask/dask-mpi";
    description = "Deploy Dask using mpi4py";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
