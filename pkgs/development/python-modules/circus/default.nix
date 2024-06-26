{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  psutil,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  pyzmq,
  tornado,
}:

buildPythonPackage rec {
  pname = "circus";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GTzoIk4GjO1mckz0gxBvtmdLUaV1g6waDn7Xp+6Mcas=";
  };

  build-system = [ flit-core ];

  dependencies = [
    psutil
    pyzmq
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  # On darwin: Too many open files
  preCheck = lib.optionalString stdenv.isDarwin ''
    ulimit -n 1024
  '';

  disabledTests = [
    # these tests raise circus.tests.support.TimeoutException
    "test_add_start"
    "test_add"
    "test_command_already_running"
    "test_dummy"
    "test_exits_within_graceful_timeout"
    "test_full_stats"
    "test_handler"
    "test_handler"
    "test_inherited"
    "test_kills_after_graceful_timeout"
    "test_launch_cli"
    "test_max_age"
    "test_reload_sequential"
    "test_reload_uppercase"
    "test_reload_wid_1_worker"
    "test_reload_wid_4_workers"
    "test_reload1"
    "test_reload2"
    "test_resource_watcher_max_cpu"
    "test_resource_watcher_max_mem_abs"
    "test_resource_watcher_max_mem"
    "test_resource_watcher_min_cpu"
    "test_resource_watcher_min_mem_abs"
    "test_resource_watcher_min_mem"
    "test_set_before_launch"
    "test_set_by_arbiter"
    "test_signal"
    "test_stdin_socket"
    "test_stop_and_restart"
    "test_stream"
    "test_venv"
    "test_watchdog_discovery_found"
    "test_watchdog_discovery_not_found"
    # this test requires socket communication
    "test_plugins"
  ];

  pythonImportsCheck = [ "circus" ];

  meta = with lib; {
    description = "Process and socket manager";
    homepage = "https://github.com/circus-tent/circus";
    changelog = "https://github.com/circus-tent/circus/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
