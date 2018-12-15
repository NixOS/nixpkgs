{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c73dae82b2a1d2a9f4ef17778f0de7a9237671a7fd3374aadd9d2bc07e92e848";
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
