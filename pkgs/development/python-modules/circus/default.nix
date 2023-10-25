{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, psutil
, pytestCheckHook
, pyyaml
, pyzmq
, tornado
}:

buildPythonPackage rec {
  pname = "circus";
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GTzoIk4GjO1mckz0gxBvtmdLUaV1g6waDn7Xp+6Mcas=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    psutil
    pyzmq
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  disabledTests = [
    # these tests raise circus.tests.support.TimeoutException
    "test_reload1"
    "test_reload2"
    "test_reload_sequential"
    "test_reload_uppercase"
    "test_reload_wid_1_worker"
    "test_reload_wid_4_workers"
    "test_add"
    "test_add_start"
    "test_command_already_running"
    "test_launch_cli"
    "test_handler"
    "test_resource_watcher_max_cpu"
    "test_resource_watcher_max_mem"
    "test_resource_watcher_max_mem_abs"
    "test_resource_watcher_min_cpu"
    "test_resource_watcher_min_mem"
    "test_resource_watcher_min_mem_abs"
    "test_full_stats"
    "test_watchdog_discovery_found"
    "test_watchdog_discovery_not_found"
    "test_dummy"
    "test_handler"
    "test_stdin_socket"
    "test_stop_and_restart"
    "test_stream"
    "test_inherited"
    "test_set_before_launch"
    "test_set_by_arbiter"
    "test_max_age"
    "test_signal"
    "test_exits_within_graceful_timeout"
    "test_kills_after_graceful_timeout"
    # this test requires socket communication
    "test_plugins"
  ];

  pythonImportsCheck = [ "circus" ];

  meta = with lib; {
    description = "A process and socket manager";
    homepage = "https://github.com/circus-tent/circus";
    license = licenses.asl20;
  };
}
