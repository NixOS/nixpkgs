{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, numpy
, psutil
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, trio
, untangle
}:

buildPythonPackage rec {
  pname = "pydevd";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "PyDev.Debugger";
    rev = "pydev_debugger_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-1tWiPj30x/ZXIBu2qzUCpyF1bLsJ0wW1QaxklD3h3A8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
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
  ] ++ lib.optionals (pythonAtLeast "3.12") [
    "test_case_handled_and_unhandled_exception_generator"
    "test_case_stop_async_iteration_exception"
    "test_case_unhandled_exception_generator"
    "test_function_breakpoints_async"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_multiprocessing_simple"
    "test_evaluate_exception_trace"
  ];

  pythonImportsCheck = [
    "pydevd"
  ];

  meta = with lib; {
    description = "PyDev.Debugger (used in PyDev, PyCharm and VSCode Python)";
    homepage = "https://github.com/fabioz/PyDev.Debugger";
    license = licenses.epl10;
    maintainers = with maintainers; [ onny ];
  };
}
