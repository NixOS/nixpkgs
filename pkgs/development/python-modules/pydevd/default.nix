{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # tests
  numpy,
  psutil,
  pytestCheckHook,
  pytest-xdist,
  pythonAtLeast,
  trio,
  untangle,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydevd";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "PyDev.Debugger";
    tag = "pydev_debugger_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-srcYeN4IsnX/B0AWLynr62UC5o+DcjnUrGjcTpvHTCM=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    numpy
    psutil
    pytest-xdist
    pytestCheckHook
    trio
    untangle
  ];

  enabledTestPaths = [
    "tests/"
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

    # Times out
    "test_case_sys_exit_multiple_exception_attach"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # raise segmentation fault
    # https://github.com/fabioz/PyDev.Debugger/issues/269
    "test_evaluate_expression"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError (strings do not match)
    "test_build_tuple"
    "test_collect_try_except_info"
    "test_collect_try_except_info2"
    "test_collect_try_except_info3"
    "test_collect_try_except_info4"
    "test_collect_try_except_info4a"
    "test_collect_try_except_info_in_single_line_1"
    "test_collect_try_except_info_in_single_line_2"
    "test_collect_try_except_info_multiple_except"
    "test_collect_try_except_info_raise_unhandled10"
    "test_collect_try_except_info_raise_unhandled7"
    "test_collect_try_except_info_return_on_except"
    "test_collect_try_except_info_with"
    "test_separate_future_import"
    "test_simple_code_to_bytecode_cls_method"
    "test_simple_code_to_bytecode_repr_return_tuple"
    "test_simple_code_to_bytecode_repr_return_tuple_with_call"
    "test_simple_code_to_bytecode_repr_simple_method_calls"
    "test_simple_code_to_bytecode_repr_tuple"
    "test_smart_step_into_bytecode_info_023a"

    # AssertionError: False is not true
    "test_if_code_obj_equals"

    # AssertionError: TimeoutError (note: error trying to dump threads on timeout: [Errno 9] Bad file descriptor).
    "test_m_switch"
    "test_module_entry_point"
    "test_multiprocessing_simple"
    "test_stop_on_start_entry_point"
    "test_stop_on_start_m_switch"

    # Failed: remains unmatched: 'Worked'
    "test_run"
    # Failed: remains unmatched: 'WorkedLocalFoo'
    "test_run_on_local_module_without_adding_to_pythonpath"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_multiprocessing_simple"
    "test_evaluate_exception_trace"
  ];

  pythonImportsCheck = [ "pydevd" ];

  meta = {
    description = "PyDev.Debugger (used in PyDev, PyCharm and VSCode Python)";
    homepage = "https://github.com/fabioz/PyDev.Debugger";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "pydevd";
  };
})
