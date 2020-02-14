{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "660cd4cd052ada872fd6413f224a2d9221026dd55a8a29a9a7d52b262bec67e7";
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
