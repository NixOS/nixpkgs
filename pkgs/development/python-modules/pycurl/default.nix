{
  lib,
  stdenv,
  buildPythonPackage,
  isPyPy,
  fetchPypi,
  pythonOlder,
  curl,
  openssl,
  bottle,
  pytestCheckHook,
  flaky,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.45.3";
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.8"; # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jCRxr5B5rXmOFkXsCw09QiPbaHN50X3TanBjdEn4HWs=";
  };

  __darwinAllowLocalNetworking = true;

  preConfigure = ''
    substituteInPlace setup.py \
      --replace-fail '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  build-system = [ setuptools ];

  buildInputs = [
    curl
    openssl
  ];

  nativeBuildInputs = [ curl ];

  nativeCheckInputs = [
    bottle
    flaky
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # don't pick up the tests directory below examples/
    "tests"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pycurl" ];

  disabledTests =
    [
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
      # https://github.com/pycurl/pycurl/issues/819
      "test_multi_socket_select"
      # https://github.com/pycurl/pycurl/issues/729
      "test_easy_pause_unpause"
      "test_multi_socket_action"
      # https://github.com/pycurl/pycurl/issues/822
      "test_request_with_verifypeer"
      # https://github.com/pycurl/pycurl/issues/836
      "test_proxy_tlsauth"
      # AssertionError: 'Москва' != '\n...
      "test_encoded_unicode_header"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Fatal Python error: Segmentation fault
      "cadata_test"
    ];

  meta = with lib; {
    description = "Python Interface To The cURL library";
    homepage = "http://pycurl.io/";
    changelog =
      "https://github.com/pycurl/pycurl/blob/REL_"
      + replaceStrings [ "." ] [ "_" ] version
      + "/ChangeLog";
    license = with licenses; [
      lgpl2Only
      mit
    ];
    maintainers = [ ];
  };
}
