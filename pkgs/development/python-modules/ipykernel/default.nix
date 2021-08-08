{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, flaky
, ipython
, jupyter_client
, traitlets
, tornado
, pythonOlder
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "5.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e976751336b51082a89fc2099fb7f96ef20f535837c398df6eab1283c2070884";
  };

  propagatedBuildInputs = [ ipython jupyter_client traitlets tornado ];

  checkInputs = [ pytestCheckHook nose flaky ];
  dontUseSetuptoolsCheck = true;
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

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
