{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  gevent,
  pika,
  prometheus-client,
  pylibmc,
  pytestCheckHook,
  pytest-cov-stub,
  redis,
  setuptools,
  watchdog,
  watchdog-gevent,
}:

buildPythonPackage rec {
  pname = "dramatiq";
  version = "1.18.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bogdanp";
    repo = "dramatiq";
    tag = "v${version}";
    hash = "sha256-noq2tWi7IUdYmRB9N3MN9oWrnNaYBgXFumOpcGw8Jn0=";
  };

  build-system = [ setuptools ];

  dependencies = [ prometheus-client ];

  optional-dependencies = {
    all = [
      gevent
      pika
      pylibmc
      redis
      watchdog
      watchdog-gevent
    ];
    gevent = [ gevent ];
    memcached = [ pylibmc ];
    rabbitmq = [ pika ];
    redis = [ redis ];
    watch = [
      watchdog
      watchdog-gevent
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pika
    redis
    pylibmc
  ];

  postPatch = ''
    sed -i ./setup.cfg \
      -e 's:--benchmark-autosave::' \
      -e 's:--benchmark-compare::' \
  '';

  disabledTests = [
    # Requires a running redis
    "test_after_process_boot_call_has_no_blocked_signals"
    "test_cli_can_be_reloaded_on_sighup"
    "test_cli_can_watch_for_source_code_changes"
    "test_cli_fork_functions_have_no_blocked_signals"
    "test_consumer_threads_have_no_blocked_signals"
    "test_middleware_fork_functions_have_no_blocked_signals"
    "test_redis_broker_can_connect_via_client"
    "test_redis_broker_can_connect_via_url"
    "test_redis_process_100k_messages_with_cli"
    "test_redis_process_10k_fib_with_cli"
    "test_redis_process_1k_latency_with_cli"
    "test_worker_threads_have_no_blocked_signals"
    # Requires a running rabbitmq
    "test_rabbitmq_broker_can_be_passed_a_list_of_parameters_for_failover"
    "test_rabbitmq_broker_can_be_passed_a_list_of_uri_for_failover"
    "test_rabbitmq_broker_can_be_passed_a_semicolon_separated_list_of_uris"
    "test_rabbitmq_broker_connections_are_lazy"
    "test_rabbitmq_process_100k_messages_with_cli"
    "test_rabbitmq_process_10k_fib_with_cli"
    "test_rabbitmq_process_1k_latency_with_cli"
    # AssertionError
    "test_cli_scrubs_stale_pid_files"
    "test_message_contains_requeue_time_after_retry"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Takes too long for darwin ofborg
    "test_retry_exceptions_can_specify_a_delay"
  ];

  pythonImportsCheck = [ "dramatiq" ];

  meta = with lib; {
    description = "Background Processing for Python 3";
    homepage = "https://github.com/Bogdanp/dramatiq";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
