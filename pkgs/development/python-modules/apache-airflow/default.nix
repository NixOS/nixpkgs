{ lib
, stdenv
, buildPythonPackage
, callPackage
, fetchFromGitHub
, fetchpatch
, mkYarnPackage
, python
, pythonOlder
, pythonAtLeast

, apache-airflow-providers-ftp
, apache-airflow-providers-http
, apache-airflow-providers-imap
, apache-airflow-providers-sqlite

, alembic
, argcomplete
, attrs
, blinker
, cached-property
, cattrs
, configparser
, colorlog_4
, connexion
, cron-descriptor
, croniter
, deprecated
, dill
, flask
, flask-appbuilder
, flask-admin
, flask-caching
, flask_login
, flask-session
, flask-swagger
, flask-wtf_0
, flask-bcrypt
, funcsigs
, future
, GitPython
, graphviz
, gunicorn
, httpx
, importlib-metadata
, importlib-resources
, jinja2
, jsonschema
, lazy-object-proxy
, linkify-it-py
, lockfile
, markdown
, markdown-it-py
, markupsafe
, marshmallow-oneofschema
, mdit-py-plugins
, packaging
, pathspec
, pendulum
, pluggy
, psutil
, pygments
, python-daemon
, python-dateutil
, python-nvd3
, python-slugify
, rich
, setproctitle
, snakebite
, sqlalchemy
, sqlalchemy-jsonfield
, tabulate
, tenacity
, termcolor
, typing-extensions
, unicodecsv
, werkzeug

, beautifulsoup4
, filelock
, freezegun
, jmespath
, parameterized
, pytest-asyncio
, pytestCheckHook
}:

let
  deselectedTestArgs = map (testPath: "--deselect '${testPath}'") deselectedTestPaths;

  # Following tests fail
  deselectedTestPaths = [
    "tests/always/test_connection.py::TestConnection::test_connection_test_hook_method_missing"
    "tests/always/test_connection.py::TestConnection::test_dbapi_get_sqlalchemy_engine"
    "tests/always/test_connection.py::TestConnection::test_dbapi_get_uri"

    "tests/api_connexion/endpoints/test_dag_run_endpoint.py::TestGetDagRunBatch"
    "tests/api_connexion/endpoints/test_dag_run_endpoint.py::TestGetDagRunBatchDateFilters"
    "tests/api_connexion/endpoints/test_dag_run_endpoint.py::TestGetDagRunsEndDateFilters"
    "tests/api_connexion/endpoints/test_dag_run_endpoint.py::TestGetDagRunsPaginationFilters"
    "tests/api_connexion/endpoints/test_dag_run_endpoint.py::TestPostDagRun"
    "tests/api_connexion/endpoints/test_mapped_task_instance_endpoint.py::TestGetMappedTaskInstances::test_mapped_task_instances_with_date"
    "tests/api_connexion/endpoints/test_task_instance_endpoint.py::TestGetTaskInstancesBatch"
    "tests/api_connexion/endpoints/test_task_instance_endpoint.py::TestGetTaskInstances"

    "tests/core/test_configuration.py::TestConf::test_config_from_secret_backend"
    "tests/core/test_configuration.py::TestConf::test_config_raise_exception_from_secret_backend_connection_error"
    "tests/core/test_configuration.py::TestConf::test_broker_transport_options"
    "tests/core/test_configuration.py::TestConf::test_auth_backends_adds_session"
    "tests/core/test_configuration.py::TestConf::test_enum_default_task_weight_rule_from_conf"
    "tests/core/test_configuration.py::TestConf::test_enum_logging_levels"
    "tests/core/test_configuration.py::TestConf::test_as_dict_works_without_sensitive_cmds"
    "tests/core/test_configuration.py::TestConf::test_as_dict_respects_sensitive_cmds_from_env"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_deprecated_options_cmd"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_both_conf_and_env_are_empty[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_both_conf_and_env_are_empty[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_config[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_config[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_env[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_env[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_disabled_env[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_disabled_env[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_disabled_config[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_cmd_disabled_config[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_secrets_disabled_env[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_secrets_disabled_env[False]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_secrets_disabled_config[True]"
    "tests/core/test_configuration.py::TestDeprecatedConf::test_conf_as_dict_when_deprecated_value_in_secrets_disabled_config[False]"
    "tests/core/test_logging_config.py::TestLoggingSettings::test_loading_remote_logging_with_wasb_handler"
    "tests/core/test_logging_config.py::TestLoggingSettings::test_log_group_arns_remote_logging_with_cloudwatch_handler_0_cloudwatch_arn_aws_logs_aaaa_bbbbb_log_group_ccccc"
    "tests/core/test_logging_config.py::TestLoggingSettings::test_log_group_arns_remote_logging_with_cloudwatch_handler_1_cloudwatch_arn_aws_logs_aaaa_bbbbb_log_group_aws_ccccc"
    "tests/core/test_logging_config.py::TestLoggingSettings::test_log_group_arns_remote_logging_with_cloudwatch_handler_2_cloudwatch_arn_aws_logs_aaaa_bbbbb_log_group_aws_ecs_ccccc"
    "tests/core/test_providers_manager.py::TestProviderManager"

    "tests/decorators/test_python_virtualenv.py::TestPythonVirtualenvDecorator"

    "tests/hooks/test_subprocess.py::TestSubprocessHook"

    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_extra_operator_links_not_loaded_in_scheduler_loop"

    "tests/operators/test_python.py::TestPythonVirtualenvOperator"

    "tests/models/test_taskinstance.py::TestMappedTaskInstanceReceiveValue::test_map_in_group"
    "tests/models/test_taskinstance.py::TestTaskInstance::test_render_k8s_pod_yaml"

    "tests/plugins/test_plugins_manager.py::TestPluginsRBAC"
    "tests/plugins/test_plugins_manager.py::TestPluginsManager::test_loads_filesystem_plugins"
    "tests/plugins/test_plugins_manager.py::TestPluginsManager::test_registering_plugin_listeners"
    "tests/plugins/test_plugins_manager.py::TestPluginsDirectorySource::test_should_return_correct_path_name"

    "tests/secrets/test_secrets.py::TestConnectionsFromSecrets::test_backend_fallback_to_env_var"
    "tests/secrets/test_secrets.py::TestConnectionsFromSecrets::test_backends_kwargs"
    "tests/secrets/test_secrets.py::TestConnectionsFromSecrets::test_initialize_secrets_backends"
    "tests/secrets/test_secrets.py::TestVariableFromSecrets::test_backend_variable_order"

    "tests/utils/test_cli_util.py::TestCliUtil::test_metrics_build" # $USER is not set
    "tests/utils/test_process_utils.py::TestKillChildProcessesByPids" # ps is not on PATH

    "tests/www/api/experimental/test_dag_runs_endpoint.py::TestDagRunsEndpoint" # http 401
    "tests/www/api/experimental/test_endpoints.py::TestPoolApiExperimental" # http 401
    "tests/www/api/experimental/test_endpoints.py::TestApiExperimental" # http 401
    "tests/www/api/experimental/test_endpoints.py::TestLineageApiExperimental" # http 401
    "tests/www/views/test_views.py::test_configuration_expose_config"
    "tests/www/views/test_views.py::test_plugin_should_list_on_page_with_details"
    "tests/www/views/test_views_acl.py::test_dag_autocomplete_success"
    "tests/www/views/test_views_acl.py::test_permission_exist"
    "tests/www/views/test_views_acl.py::test_role_permission_associate"
    "tests/www/views/test_views_extra_links.py::test_global_extra_links_works"
    "tests/www/views/test_views_extra_links.py::test_extra_link_in_gantt_view"
    "tests/www/views/test_views_extra_links.py::test_operator_extra_link_override_plugin"
    "tests/www/views/test_views_extra_links.py::test_operator_extra_link_multiple_operators"

    # Missing provider
    "tests/task/task_runner/test_task_runner.py::GetTaskRunner::test_should_have_valid_imports_1_airflow_task_task_runner_cgroup_task_runner_CgroupTaskRunner"
    "tests/api/auth/test_client.py::TestGetCurrentApiClient::test_should_create_google_open_id_client"

    # Celery and Kubernetes missing
    "tests/executors/test_executor_loader.py::TestExecutorLoader::test_should_support_executor_from_core_0_CeleryExecutor"
    "tests/executors/test_executor_loader.py::TestExecutorLoader::test_should_support_executor_from_core_1_CeleryKubernetesExecutor"
    "tests/executors/test_executor_loader.py::TestExecutorLoader::test_should_support_executor_from_core_3_KubernetesExecutor"
  ] ++ lib.optionals stdenv.isDarwin [
    "tests/dag_processing/test_manager.py::TestDagFileProcessorAgent::test_parse_once"
    "tests/dag_processing/test_manager.py::TestDagFileProcessorManager::test_dag_with_system_exit"
    "tests/executors/test_local_executor.py::TestLocalExecutor::test_execution_limited_parallelism_fork"
    "tests/executors/test_local_executor.py::TestLocalExecutor::test_execution_subprocess_limited_parallelism"
    "tests/executors/test_local_executor.py::TestLocalExecutor::test_execution_subprocess_unlimited_parallelism"
    "tests/executors/test_local_executor.py::TestLocalExecutor::test_execution_unlimited_parallelism_fork"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_fail"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_success"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_root_fail"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_root_fail_unfinished"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_root_after_dagrun_unfinished"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_deadlock_ignore_depends_on_past_advance_ex_date"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_dagrun_deadlock_ignore_depends_on_past"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_start_date[configs0]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_start_date[configs1]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_task_start_date[configs0]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_task_start_date[configs1]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_multiprocessing[configs0]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_scheduler_multiprocessing[configs1]"
    "tests/jobs/test_scheduler_job.py::TestSchedulerJob::test_retry_still_in_executor"
    "tests/operators/test_bash.py::TestBashOperator::test_bash_operator_kill"
    "tests/utils/test_process_utils.py::TestCheckIfPidfileProcessIsRunning::test_remove_if_no_process"
  ];

in
buildPythonPackage rec {
  pname = "apache-airflow";
  version = "2.3.3";
  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "sha256-WRl9g36X+n0uh10YuvY48c84B99b06Y675tLo/R3gJI=";

    # HACK: The zip sources doesn't have tests folder.
    #       This forces git fetch instead of zip fetch.
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    apache-airflow-providers-ftp
    apache-airflow-providers-http
    apache-airflow-providers-imap
    apache-airflow-providers-sqlite

    alembic
    argcomplete
    attrs
    blinker
    cattrs
    colorlog_4
    connexion
    cron-descriptor
    croniter
    deprecated
    dill
    flask
    flask-appbuilder
    flask-caching
    flask_login
    flask-session
    flask-wtf_0
    GitPython
    graphviz
    gunicorn
    httpx
    jinja2
    jsonschema
    lazy-object-proxy
    linkify-it-py
    lockfile
    markdown
    markdown-it-py
    markupsafe
    marshmallow-oneofschema
    mdit-py-plugins
    packaging
    pathspec
    pendulum
    pluggy
    psutil
    pygments
    python-daemon
    python-dateutil
    python-nvd3
    python-slugify
    rich
    setproctitle
    sqlalchemy
    sqlalchemy-jsonfield
    tabulate
    tenacity
    termcolor
    typing-extensions
    unicodecsv
    werkzeug
  ] ++ lib.optional (pythonOlder "3.8") [
    cached-property
  ] ++ lib.optional (pythonOlder "3.9") [
    importlib-metadata
    importlib-resources
  ];

  checkInputs = [
    beautifulsoup4
    filelock
    freezegun
    jmespath
    parameterized
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "attrs>=20.0,<21.0" "attrs>=20.0" \
      --replace "cattrs~=1.1, !=1.7.*" "cattrs" \
  '';

  # allow for gunicorn processes to have access to Python packages
  makeWrapperArgs = [
    "--prefix PYTHONPATH : $PYTHONPATH"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin

    airflow version
    airflow db init
    airflow db reset -y
  '';

  pytestFlagsArray = [
    "--disable-pytest-warnings"
  ] ++ deselectedTestArgs;

  ## Following tests fail while init due to import error
  disabledTestPaths = [
    # Requires celery
    "tests/cli/"
    "tests/executors/test_celery_executor.py"
    "tests/executors/test_celery_kubernetes_executor.py"
    "tests/executors/test_kubernetes_executor.py"
    "tests/executors/test_local_kubernetes_executor.py"
    "tests/www/views/test_views_dagrun.py"
    "tests/www/views/test_views_tasks.py"

    # Requires docker
    "docker_tests/"

    # Requires kubernetes
    "kubernetes_tests/"
    "tests/kubernetes/"
    "tests/serialization/test_dag_serialization.py"

    # Requires dask
    "tests/executors/test_dask_executor.py"

    # Requires cgroupspy
    "tests/task/task_runner/test_cgroup_task_runner.py"

    # Requires psycopg
    "tests/operators/test_generic_transfer.py"
    "tests/operators/test_sql.py"

    # Requires statsd
    "tests/core/test_stats.py"

    # Requires numpy
    "tests/utils/test_json.py"

    # Requires pandas
    "tests/sensors/test_sql_sensor.py"

    # Requires sentry_sdk
    "tests/core/test_sentry.py"

    # Most of them requires helm/kubernetes
    "tests/charts/"

    # Requires google
    "tests/api_connexion/endpoints/test_extra_link_endpoint.py"

    # Requires kerberos
    "tests/api/auth/backend/test_kerberos_auth.py"

    # Requires breeze
    "dev/breeze/tests/"

    # Uses all providers, but not are installed
    "tests/always/test_deprecations.py"
    "tests/always/test_example_dags.py"
    "tests/providers/"
    "tests/system/providers/"
  ];


  postInstall = let
    frontend = callPackage ./frontend.nix {
      inherit mkYarnPackage;
      src = "${src}/airflow/www";
    };
    in ''
      cp -rv ${frontend}/static/dist $out/${python.sitePackages}/airflow/www/static
    '';

  meta = with lib; {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = "https://airflow.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple costrouc ingenieroariel ];
  };
}
