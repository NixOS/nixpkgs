{
  lib,
  stdenv,
  buildPythonPackage,
  flaky,
  ipykernel,
  ipyparallel,
  pre-commit,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
}:

buildPythonPackage {
  pname = "ipykernel-tests";
  inherit (ipykernel) version src;
  pyproject = false;

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

  disabledTests = [
    # The following three tests fail for unclear reasons.
    # pytest.PytestUnhandledThreadExceptionWarning: Exception in thread Thread-8
    "test_asyncio_interrupt"

    # DeprecationWarning: Passing unrecognized arguments to super(IPythonKernel)
    "test_embed_kernel_func"

    # traitlets.config.configurable.MultipleInstanceError: An incompatible siblin...
    "test_install_kernelspec"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # see https://github.com/NixOS/nixpkgs/issues/76197
    "test_subprocess_print"
    "test_subprocess_error"
    "test_ipython_start_kernel_no_userns"

    # https://github.com/ipython/ipykernel/issues/506
    "test_unc_paths"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;
}
