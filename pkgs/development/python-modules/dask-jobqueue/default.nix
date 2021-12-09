{ lib
, buildPythonPackage
, dask
, distributed
, docrep
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "dask-jobqueue";

  src = fetchFromGitHub {
     owner = "dask";
     repo = "dask-jobqueue";
     rev = "0.7.3";
     sha256 = "060yndyv2i7vrrfca5xg1xkx5g0kdb8asp1ddwvsyy58rznjs63h";
  };

  propagatedBuildInputs = [
    dask
    distributed
    docrep
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Do not run entire tests suite (requires slurm, sge, etc.)
    "dask_jobqueue/tests/test_jobqueue_core.py"
  ];

  disabledTests = [
    "test_import_scheduler_options_from_config"
    "test_security"
  ];

  pythonImportsCheck = [ "dask_jobqueue" ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-jobqueue";
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
