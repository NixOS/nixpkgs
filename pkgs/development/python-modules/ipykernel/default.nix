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
  version = "5.1.3";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a08y677lpn80qzvv7z0smgggmr5m5ayf0bs6vds47xpxl9sss5k";
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
  disabledTests = lib.optionals stdenv.isDarwin [
    # see https://github.com/NixOS/nixpkgs/issues/76197
    "test_subprocess_print"
    "test_subprocess_error"
    "test_ipython_start_kernel_no_userns"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
