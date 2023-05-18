{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, flaky
, ipykernel
, ipyparallel
, nose
, pytestCheckHook

}:

buildPythonPackage rec {
  pname = "ipykernel-tests";
  inherit (ipykernel) version;

  src = ipykernel.src;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    flaky
    ipykernel
    ipyparallel
    nose
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = lib.optionals stdenv.isDarwin ([
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
