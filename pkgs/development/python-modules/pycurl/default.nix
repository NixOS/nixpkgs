{ lib
, buildPythonPackage
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
  version = "7.45.0";
  disabled = isPyPy || (pythonOlder "3.5"); # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UDbFPG9BBukWDQU6S6o0M6AhX7M4YHPiESc8VqOpXz0=";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

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

  pytestFlagsArray = [
    # don't pick up the tests directory below examples/
    "tests"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # libcurl stopped passing the reason phrase from the HTTP status line
    # https://github.com/pycurl/pycurl/issues/679
    "test_failonerror"
    "test_failonerror_status_line_invalid_utf8_python3"
    # bottle>=0.12.17 escapes utf8 properly, so these test don't work anymore
    # https://github.com/pycurl/pycurl/issues/669
    "test_getinfo_content_type_invalid_utf8_python3"
    "test_getinfo_cookie_invalid_utf8_python3"
    "test_getinfo_raw_content_type_invalid_utf8"
    "test_getinfo_raw_cookie_invalid_utf8"
    # tests that require network access
    "test_keyfunction"
    "test_keyfunction_bogus_return"
    # OSError: tests/fake-curl/libcurl/with_openssl.so: cannot open shared object file: No such file or directory
    "test_libcurl_ssl_openssl"
    # OSError: tests/fake-curl/libcurl/with_nss.so: cannot open shared object file: No such file or directory
    "test_libcurl_ssl_nss"
    # OSError: tests/fake-curl/libcurl/with_gnutls.so: cannot open shared object file: No such file or directory
    "test_libcurl_ssl_gnutls"
    # AssertionError: assert 'crypto' in ['curl']
    "test_ssl_in_static_libs"
  ];

  meta = with lib; {
    homepage = "http://pycurl.sourceforge.net/";
    description = "Python wrapper for libcurl";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [];
  };
}
