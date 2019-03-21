{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, distributed
, mpi4py
, pytest
, requests
}:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1apzzh90gl9jx43z0gjmgpniplhvqziafi2l8688a0g01vw7ibjv";
  };

  checkInputs = [ pytest requests ];
  propagatedBuildInputs = [ dask distributed mpi4py ];

  checkPhase = ''
    py.test dask_mpi
  '';

  # hardcoded mpirun path in tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dask/dask-mpi;
    description = "Deploy Dask using mpi4py";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
