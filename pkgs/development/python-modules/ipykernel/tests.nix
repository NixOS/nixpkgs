{
  lib,
  stdenv,
  buildPythonPackage,
  flaky,
  ipykernel,
  ipyparallel,
  pre-commit,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-timeout,
  trio,
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
    pytest-asyncio
    pytestCheckHook
    pytest-cov-stub
    pytest-timeout
    trio
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
