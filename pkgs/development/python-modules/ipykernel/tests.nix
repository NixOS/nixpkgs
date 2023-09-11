{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, flaky
, ipykernel
, ipyparallel
, pre-commit
, pytestCheckHook
, pytest-asyncio
, pytest-timeout
}:

buildPythonPackage {
  pname = "ipykernel-tests";
  inherit (ipykernel) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    flaky
    ipykernel
    ipyparallel
    pre-commit
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ # The follwing three tests fail for unclear reasons.
    # pytest.PytestUnhandledThreadExceptionWarning: Exception in thread Thread-8
    "test_asyncio_interrupt"

    # DeprecationWarning: Passing unrecognized arguments to super(IPythonKernel)
    "test_embed_kernel_func"

    # traitlets.config.configurable.MultipleInstanceError: An incompatible siblin...
    "test_install_kernelspec"
  ] ++ lib.optionals stdenv.isDarwin ([
    # see https://github.com/NixOS/nixpkgs/issues/76197
    "test_subprocess_print"
    "test_subprocess_error"
    "test_ipython_start_kernel_no_userns"

    # https://github.com/ipython/ipykernel/issues/506
    "test_unc_paths"
  ] ++ lib.optionals (pythonOlder "3.8") [
    # flaky test https://github.com/ipython/ipykernel/issues/485
    "test_shutdown"

    # test regression https://github.com/ipython/ipykernel/issues/486
    "test_sys_path_profile_dir"
    "test_save_history"
    "test_help_output"
    "test_write_kernel_spec"
    "test_ipython_start_kernel_userns"
    "ZMQDisplayPublisherTests"
  ]);

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;
}
