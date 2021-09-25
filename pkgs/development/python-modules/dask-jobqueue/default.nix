{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
, docrep
, pytest
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "682d7cc0e6b319b6ab83a7a898680c12e9c77ddc77df380b40041290f55d4e79";
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
