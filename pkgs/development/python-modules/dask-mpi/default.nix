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
  version = "1.0.3";
  pname = "dask-mpi";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e81ca2269eb96f928b2c308aa5eb687e114e5b470924ca8d480fe3bc1b599c6b";
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
