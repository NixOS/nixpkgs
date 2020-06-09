{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.7.1";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d32ddf3e3c7db29ace102037fa5f61c8db2d945176454dc316a6ffdb8bbfe88b";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ dask distributed docrep ];

  # do not run entire tests suite (requires slurm, sge, etc.)
  checkPhase = ''
    py.test dask_jobqueue/tests/test_jobqueue_core.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/dask/dask-jobqueue";
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
