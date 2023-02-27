{ lib
, stdenv
, buildPythonPackage
, isPyPy
, fetchPypi
, fetchpatch
, pythonOlder
, curl
, openssl
, bottle
, pytestCheckHook
, flaky
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.45.1";
  disabled = isPyPy || (pythonOlder "3.5"); # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qGOtGP9Hj1VFkkBXiHza5CLhsnRuQWdGFfaHSY6luIo=";
  };

  patches = [
    # Pull upstream patch for curl-3.83:
    #  https://github.com/pycurl/pycurl/pull/753
    (fetchpatch {
      name = "curl-3.83.patch";
      url = "https://github.com/pycurl/pycurl/commit/d47c68b1364f8a1a45ab8c584c291d44b762f7b1.patch";
      sha256 = "sha256-/lGq7O7ZyytzBAxWJPigcWdvypM7OHLBcp9ItmX7z1g=";
    })
  ];

  preConfigure = ''
    substituteInPlace setup.py --replace '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  buildInputs = [
    curl
    openssl
  ];

  nativeBuildInputs = [
    curl
  ];

  nativeCheckInputs = [
    bottle
    pytestCheckHook
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
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fatal Python error: Segmentation fault
    "cadata_test"
  ];

  meta = with lib; {
    homepage = "http://pycurl.io/";
    description = "Python Interface To The cURL library";
    license = with licenses; [ lgpl2Only mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
