{ stdenv
, lib
, buildPythonPackage
, dask
, distributed
, docrep
, fetchPypi
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "dask-jobqueue";

  src = fetchPypi {
    inherit pname version;
    sha256 = "682d7cc0e6b319b6ab83a7a898680c12e9c77ddc77df380b40041290f55d4e79";
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
    broken = stdenv.isDarwin;
    homepage = "https://github.com/dask/dask-jobqueue";
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
