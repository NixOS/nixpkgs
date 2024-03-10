{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, gevent
, pika
, prometheus-client
, pylibmc
, pytestCheckHook
, redis
, watchdog
, watchdog-gevent
}:

buildPythonPackage rec {
  pname = "dramatiq";
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bogdanp";
    repo = "dramatiq";
    rev = "refs/tags/v${version}";
    hash = "sha256-gC1vWnG3zDuFT61i2VgDrP/qIwmGN5GkGv6EVxqUf4U=";
  };

  propagatedBuildInputs = [
    prometheus-client
  ];

  passthru.optional-dependencies = {
    all = [
      gevent
      pika
      pylibmc
      redis
      watchdog
      watchdog-gevent
    ];
    gevent = [
      gevent
    ];
    memcached = [
      pylibmc
    ];
    rabbitmq = [
      pika
    ];
    redis = [
      redis
    ];
    watch = [
      watchdog
      watchdog-gevent
    ];
  };

  nativeCheckInputs = [ pytestCheckHook pika redis pylibmc ];

  postPatch = ''
    sed -i ./setup.cfg \
      -e 's:--cov dramatiq::' \
      -e 's:--cov-report html::' \
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
  ] ++ lib.optionals stdenv.isDarwin [
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
