{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "5.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f1f01df22f1229c8879501057877ccaf92a3b01c1d00db708aad5003e5f9238";
  };

  propagatedBuildInputs = [ ipython jupyter_client traitlets tornado ];

  # https://github.com/ipython/ipykernel/pull/377
  patches = [
    (fetchpatch {
      url = "https://github.com/ipython/ipykernel/commit/a3bf849dbd368a1826deb9dfc94c2bd3e5ed04fe.patch";
      sha256 = "1yhpwqixlf98a3n620z92mfips3riw6psijqnc5jgs2p58fgs2yc";
    })
  ];

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
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
