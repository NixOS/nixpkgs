{ lib
, stdenv
, buildPythonPackage
, isPyPy
, fetchPypi
, pythonOlder
, curl
, openssl
, bottle
, pytestCheckHook
, flaky
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.45.2";
  disabled = isPyPy || (pythonOlder "3.5"); # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VzBZC+AnE2Slvd2eJFycwPtxDEy6y92VJkoxItIyJMo=";
  };

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

  __darwinAllowLocalNetworking = true;

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
    # tests that require curl with http3Support
    "test_http_version_3"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fatal Python error: Segmentation fault
    "cadata_test"
  ];

  meta = with lib; {
    homepage = "http://pycurl.io/";
    description = "Python Interface To The cURL library";
    license = with licenses; [ lgpl2Only mit ];
    maintainers = with maintainers; [ ];
  };
}
