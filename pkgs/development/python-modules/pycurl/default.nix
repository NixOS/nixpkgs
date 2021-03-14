{ buildPythonPackage
, isPyPy
, fetchPypi
, pythonOlder
, curl
, openssl
, bottle
, pytestCheckHook
, nose
, flaky
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.43.0.6";
  disabled = isPyPy || (pythonOlder "3.5"); # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "8301518689daefa53726b59ded6b48f33751c383cf987b0ccfbbc4ed40281325";
  };

  buildInputs = [
    curl
    openssl.out
  ];

  nativeBuildInputs = [
    curl
  ];

  checkInputs = [
    bottle
    pytestCheckHook
    nose
    flaky
  ];

  preConfigure = ''
    substituteInPlace setup.py --replace '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  # skip impure or flakey tests
  # See also:
  #   * https://github.com/NixOS/nixpkgs/issues/77304
  disabledTestPaths = [
    "tests/getinfo_test.py"
    "tests/memory_mgmt_test.py"
    "tests/multi_memory_mgmt_test.py"
    "tests/multi_timer_test.py"
  ];

  disabledTests = [
    "test_keyfunction"
    "test_keyfunction_bogus_return"
    "test_libcurl_ssl_gnutls"
    "test_libcurl_ssl_nss"
    "test_libcurl_ssl_openssl"
    "test_ssl_in_static_libs"
  ];

  meta = {
    homepage = "http://pycurl.sourceforge.net/";
    description = "Python wrapper for libcurl";
    maintainers = [];
  };
}
