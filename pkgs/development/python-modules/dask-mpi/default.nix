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
  version = "2.0.0";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "774cd2d69e5f7154e1fa133c22498062edd31507ffa2ea19f4ab4d8975c27bc3";
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
