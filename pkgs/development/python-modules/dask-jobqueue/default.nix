{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e559077fd27b68c325f06e3666e7072913f5282ad62347a233ca95ae00a4ced7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ dask distributed docrep ];

  # do not run entire tests suite (requires slurm, sge, etc.)
  checkPhase = ''
    py.test dask_jobqueue/tests/test_jobqueue_core.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/dask/dask-jobqueue;
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
