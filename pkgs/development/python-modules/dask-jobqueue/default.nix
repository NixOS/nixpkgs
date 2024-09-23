{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dask,
  distributed,

  # checks
  cryptography,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-jobqueue";
  version = "0.8.5";
  pyproject = true;

  # Python 3.12 support should be added in 0.8.6
  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-jobqueue";
    rev = "refs/tags/${version}";
    hash = "sha256-NBFfPTNIXezwv7f1P3VRnkBYlOutD30+8rdiBBssHDE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dask
    distributed
  ];

  nativeCheckInputs = [
    cryptography
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Require some unavailable pytest fixtures
    "test_adapt"
    "test_adaptive"
    "test_adaptive_cores_mem"
    "test_adaptive_grouped"
    "test_adapt_parameters"
    "test_basic"
    "test_basic_scale_edge_cases"
    "test_cluster"
    "test_cluster_error_scheduler_arguments_should_use_scheduler_options"
    "test_cluster_has_cores_and_memory"
    "test_command_template"
    "test_complex_cancel_command"
    "test_config"
    "test_dashboard_link"
    "test_default_number_of_worker_processes"
    "test_deprecation_env_extra"
    "test_deprecation_extra"
    "test_deprecation_job_extra"
    "test_different_interfaces_on_scheduler_and_workers"
    "test_docstring_cluster"
    "test_extra_args_broken_cancel"
    "test_forward_ip"
    "test_import_scheduler_options_from_config"
    "test_job"
    "test_jobqueue_job_call"
    "test_log_directory"
    "test_scale_cores_memory"
    "test_scale_grouped"
    "test_scheduler_options"
    "test_scheduler_options_interface"
    "test_security"
    "test_security_temporary"
    "test_security_temporary_defaults"
    "test_shebang_settings"
    "test_use_stdin"
    "test_worker_name_uses_cluster_name"
    "test_wrong_parameter_error"
  ];

  pythonImportsCheck = [ "dask_jobqueue" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Deploy Dask on job schedulers like PBS, SLURM, and SGE";
    homepage = "https://github.com/dask/dask-jobqueue";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
