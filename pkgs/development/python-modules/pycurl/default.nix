{
  lib,
  stdenv,
  buildPythonPackage,
  isPyPy,
  fetchFromGitHub,
  fetchpatch2,
  curl,
  openssl,
  bottle,
  pytestCheckHook,
  flaky,
  flask,
  numpy,
  websockets,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.46.0";
  pyproject = true;

  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchFromGitHub {
    owner = "pycurl";
    repo = "pycurl";
    tag = "REL_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-F40bJ7TYFK2dVkDJGGxl7XV46fKmjwvUYYulcwGL6hk=";
  };

  patches = [
    (fetchpatch2 {
      name = "pycurl-curl-8.21.0-ws-support.patch";
      url = "https://github.com/pycurl/pycurl/commit/c78fd8aba82e2f8037275063138eaa7706c111af.diff?full_index=1";
      hash = "sha256-EBXgGiaMtXTsgJOOrzzZFJ7Q/ofAlc4zuipoEpfdFqU=";
    })
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace-fail '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ curl ];

  buildInputs = [
    curl
    openssl
  ];

  pythonImportsCheck = [ "pycurl" ];

  nativeCheckInputs = [
    bottle
    flaky
    flask
    numpy
    websockets
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  enabledTestPaths = [
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
    # expected socketp to be None again after unassign()
    "test_clear_via_assign_none_inside_callback_resets_socketp"
    "test_multi_unassign_inside_socket_callback"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    "cadata_test"
  ];

  meta = {
    description = "Python Interface To The cURL library";
    homepage = "http://pycurl.io/";
    changelog =
      "https://github.com/pycurl/pycurl/blob/REL_"
      + lib.replaceStrings [ "." ] [ "_" ] version
      + "/ChangeLog";
    license = with lib.licenses; [
      lgpl2Only
      mit
    ];
    maintainers = [ ];
  };
}
