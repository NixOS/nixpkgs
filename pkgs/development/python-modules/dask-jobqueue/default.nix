{ stdenv
, lib
, buildPythonPackage
, dask
, distributed
, docrep
, fetchPypi
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dask-jobqueue";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VCD6Oos9aSkbrzymQnqm2RV5uFzTj05VgPuhJ5PpyAk=";
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

  pythonImportsCheck = [
    "dask_jobqueue"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    homepage = "https://github.com/dask/dask-jobqueue";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
