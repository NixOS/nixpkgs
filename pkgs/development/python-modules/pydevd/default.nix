{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  numpy,
  psutil,
  pytest-xdist,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  trio,
  untangle,
}:

buildPythonPackage rec {
  pname = "pydevd";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "PyDev.Debugger";
    rev = "pydev_debugger_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-V5pM0xnMFnpR1oK0purHFCV3wu+4fOmd72kmy7pVeyk=";
  };

  postPatch = ''
    sed -i '/addopts/d' pytest.ini
  '';

  __darwinAllowLocalNetworking = true;

  build-system = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    numpy
    psutil
    #pytest-xdist
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
    # Times out
    "test_case_sys_exit_multiple_exception_attach"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # raise segmentation fault
    # https://github.com/fabioz/PyDev.Debugger/issues/269
    "test_evaluate_expression"
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
}
