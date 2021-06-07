{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.7.2";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1767f4146b2663d9d2eaef62b882a86e1df0bccdb8ae68ae3e5e546aa6796d35";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ dask distributed docrep ];

  # do not run entire tests suite (requires slurm, sge, etc.)
  checkPhase = ''
    py.test dask_jobqueue/tests/test_jobqueue_core.py
  '';

  meta = with lib; {
    homepage = "https://github.com/dask/dask-jobqueue";
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    broken = true;
  };
}
