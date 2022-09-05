{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, untangle
, psutil
, trio
, numpy
}:

buildPythonPackage rec {
  pname = "pydevd";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "PyDev.Debugger";
    rev = "pydev_debugger_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-+yRngN10654trB09ZZa8QQsTPdM7VxVj7r6jh7OcgAA=";
  };

  checkInputs = [
    numpy
    psutil
    pytestCheckHook
    trio
    untangle
  ];

  disabledTests = [
    # Require network connection
    "test_completion_sockets_and_messages"
    "test_path_translation"
    "test_attach_to_pid_no_threads"
    "test_attach_to_pid_halted"
    "test_remote_debugger_threads"
    "test_path_translation_and_source_reference"
    "test_attach_to_pid"
    "test_terminate"
    "test_gui_event_loop_custom"
    # AssertionError: assert '/usr/bin/' == '/usr/bin'
    # https://github.com/fabioz/PyDev.Debugger/issues/227
    "test_to_server_and_to_client"
    # AssertionError pydevd_tracing.set_trace_to_threads(tracing_func) == 0
    "test_tracing_other_threads"
    "test_tracing_basic"
  ];

  pythonImportsCheck = [ "pydevd" ];

  meta = with lib; {
    description = "PyDev.Debugger (used in PyDev, PyCharm and VSCode Python)";
    homepage = "https://github.com/fabioz/PyDev.Debugger";
    license = licenses.epl10;
    maintainers = with maintainers; [ onny ];
  };
}
