{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, psutil
, pytestCheckHook
, pythonOlder
, trio
, untangle
}:

buildPythonPackage rec {
  pname = "pydevd";
  version = "2.9.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "PyDev.Debugger";
    rev = "pydev_debugger_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-TDU/V7kY7zVxiP4OVjGqpsRVYplpkgCly2qAOqhZONo=";
  };

  patches = [
    # https://github.com/fabioz/PyDev.Debugger/pull/258
    (fetchpatch {
      name = "numpy-1.25-test-compatibility.patch";
      url = "https://github.com/fabioz/PyDev.Debugger/commit/6f637d951cda62dc2202a2c7b6af526c4d1e8a00.patch";
      hash = "sha256-DLzZZwQHtqGZGA8nsBLNQqamuI4xUfQ89Gd21sJa9/s=";
    })
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
