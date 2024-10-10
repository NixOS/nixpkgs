{
  lib,
  buildPythonPackage,
  python,
  callPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  configargparse,
  cryptography,
  flask,
  flask-cors,
  flask-login,
  gevent,
  geventhttpclient,
  msgpack,
  psutil,
  pyquery,
  pyzmq,
  requests,
  retry,
  tomli,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "locust";
  version = "2.31.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    rev = "refs/tags/${version}";
    hash = "sha256-xDquVQjkWVER9h0a6DHWRZH6KtRf0jsThycSojDEdh4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'script = "pre_build.py"' ""

    substituteInPlace locust/test/test_main.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'

    substituteInPlace locust/test/test_log.py \
      --replace-fail '"locust"' '"${placeholder "out"}/bin/locust"'
  '';

  webui = callPackage ./webui.nix {
    inherit version;
    src = "${src}/locust/webui";
  };

  preBuild = ''
    mkdir -p $out/${python.sitePackages}/${pname}
    ln -sf ${webui} $out/${python.sitePackages}/${pname}/webui
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    # version 0.7.0.dev0 is not considered to be >= 0.6.3
    "flask-login"
  ];

  dependencies = [
    configargparse
    flask
    flask-cors
    flask-login
    gevent
    geventhttpclient
    msgpack
    psutil
    pyzmq
    requests
    tomli
    werkzeug
  ];

  pythonImportsCheck = [ "locust" ];

  nativeCheckInputs = [
    cryptography
    pyquery
    pytestCheckHook
    retry
  ];

  # a lot of tests require internet access, attempt operations that are not permitted in the
  # sandbox, or are highly sensitive to the current load on the machine
  disabledTests = [
    "test_autostart_multiple_locustfiles_with_shape"
    "test_autostart_w_load_shape"
    "test_autostart_wo_run_time"
    "test_can_call_stop_endpoint_if_currently_swarming"
    "test_can_call_stop_endpoint_if_currently_swarming"
    "test_catch_response"
    "test_catch_response_allow_404"
    "test_client_basic_auth"
    "test_client_delete"
    "test_client_get"
    "test_client_get_absolute_url"
    "test_client_head"
    "test_client_post"
    "test_client_put"
    "test_client_request_headers"
    "test_constant_throughput"
    "test_cpu_warning"
    "test_csv_stats_writer_full_history"
    "test_custom_arguments"
    "test_custom_arguments_in_file"
    "test_distributed"
    "test_distributed_events"
    "test_distributed_integration_run"
    "test_distributed_rebalanced_integration_run"
    "test_distributed_report_timeout_expired"
    "test_distributed_run_with_custom_args"
    "test_distributed_shape"
    "test_distributed_shape_statuses_transition"
    "test_distributed_shape_stop_and_restart"
    "test_distributed_stop_with_stopping_state"
    "test_distributed_tags"
    "test_distributed_update_user_class"
    "test_distributed_with_locustfile_distribution_not_plain_filename"
    "test_expect_workers"
    "test_get_request"
    "test_heartbeat_event"
    "test_html_report_option"
    "test_json_schema"
    "test_kill_locusts_with_stop_timeout"
    "test_kill_locusts_with_stop_timeout"
    "test_last_worker_missing_stops_test"
    "test_locustfile_distribution"
    "test_locustfile_distribution_with_workers_started_first"
    "test_locustfile_from_url"
    "test_long_running_test_start_is_run_to_completion_on_worker"
    "test_percentile_parameter"
    "test_percentiles_to_statistics"
    "test_pool_manager_per_user_instance"
    "test_processes"
    "test_processes_autodetect"
    "test_processes_ctrl_c"
    "test_processes_error_doesnt_blow_up_completely"
    "test_processes_separate_worker"
    "test_request_stats_content_length"
    "test_request_stats_no_content_length"
    "test_run_autostart_with_multiple_locustfiles"
    "test_shared_pool_manager"
    "test_spawning_complete_and_test_stop_event"
    "test_stats_history"
    "test_stop_timeout"
    "test_stop_timeout_with_interrupt_no_reschedule"
    "test_stop_users_with_spawn_rate"
    "test_swarm_endpoint_is_non_blocking"
    "test_swarm_endpoint_is_non_blocking"
    "test_target_user_count_is_set_before_ramp_up"
    "test_usage_monitor_event"
    "test_user_count_in_csv_history_stats"
    "test_user_count_starts_from_specified_amount_when_creating_new_test_after_previous_step_has_been_stopped"
    "test_wait_for_workers_report_after_ramp_up"
    "test_webserver"
    "test_webserver_multiple_locustfiles"
    "test_webserver_multiple_locustfiles_in_directory"
    "test_webserver_multiple_locustfiles_with_shape"
    "test_worker_indexes"
    "test_worker_missing_after_heartbeat_dead_interval"
    "test_workers_shut_down_if_master_is_gone"
    "test_default_wait_time"
  ];

  disabledTestPaths = [
    "examples/test_data_management.py"
    "locust/test/test_dispatch.py"
    "locust/test/test_fasthttp.py"
    "locust/test/test_http.py"
    "locust/test/test_web.py"
    "locust/test/test_zmqrpc.py"
  ];

  meta = {
    description = "Developer-friendly load testing framework";
    homepage = "https://docs.locust.io/";
    changelog = "https://github.com/locustio/locust/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
