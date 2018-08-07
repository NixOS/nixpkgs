{ lib
, buildPythonPackage
, fetchPypi
, pytest
, dask
, distributed
, docrep
}:

buildPythonPackage rec {
  pname = "dask-jobqueue";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc1bca08781dea9007bd7407f72921b94c524e2489f21c23f56a2d685e72911";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ dask distributed docrep ];

  checkPhase = ''
    py.test dask_jobqueue
  '';

  # tests required slurm, sge, schedulers to be available
  doCheck = false;

  meta = {
    description = "Easy deployment of Dask Distributed on job queuing systems such as PBS, Slurm, or SGE.*";
    homepage = https://github.com/dask/dask-jobqueue;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}