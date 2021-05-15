{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, pytestCheckHook
, sphinx
, stdenv
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57edce81c837f3c2cf42fbb346dee26e537d1659e6605269fb13bd179e068744";
  };

  patches = [
    # Fix the flaky test due to slow moving time on Apple Silicon chips.
    # Remove when https://github.com/dabeaz/curio/pull/339 is in the next release.
    (fetchpatch {
      url = "https://github.com/dabeaz/curio/commit/132376724bbfaa0a52d3d63d0791aa4ac1eb6f5f.patch";
      sha256 = "sha256-AxO0xRcR9l9/NKEJFwyZIoYcyZxpqOhpdNaeaYokVb4=";
    })
    # Same as above
    (fetchpatch {
      url = "https://github.com/dabeaz/curio/commit/8ac2f12a2cdacbc750b01fc7459cee8879bc1ee3.patch";
      sha256 = "sha256-2Si3fuDLrI09QuzJd1TrE0QY02G9e9m+1eHFTB/MrWU=";
    })
  ];

  disabled = !isPy3k;

  checkInputs = [ pytestCheckHook sphinx ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
     "test_aside_basic" # times out
     "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
     "test_ssl_outgoing" # touches network
   ] ++ lib.optionals (stdenv.isDarwin) [
     "test_unix_echo" # socket bind error on hydra when built with other packages
     "test_unix_ssl_server" # socket bind error on hydra when built with other packages
   ];

  meta = with lib; {
    homepage = "https://github.com/dabeaz/curio";
    description = "Library for performing concurrent I/O with coroutines in Python 3";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
