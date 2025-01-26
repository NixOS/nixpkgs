{
  lib,
  stdenv,
  buildPythonPackage,
  isPyPy,
  fetchFromGitHub,
  curl,
  openssl,
  bottle,
  pytestCheckHook,
  flaky,
  flask,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.45.3-unstable-2024-10-17";
  pyproject = true;

  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchFromGitHub {
    owner = "pycurl";
    repo = "pycurl";
    # Pinned to newer commit, since the release cadence is not keeping up with curl itself
    #rev = "refs/tags/REL_${lib.replaceStrings [ "." ] [ "_" ] version}";
    rev = "885d08b4d3cbc59547b8b80fbd13ab5fc6f27238";
    hash = "sha256-WnrQhv6xiA+/Uz0hUmQxmEUasxtvlIV2EjlO+ZOUgI8=";
  };

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
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    # don't pick up the tests directory below examples/
    "tests"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

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
      # https://github.com/pycurl/pycurl/issues/819
      "test_multi_socket_select"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # https://github.com/pycurl/pycurl/issues/729
      "test_easy_pause_unpause"
      "test_multi_socket_action"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Fatal Python error: Segmentation fault
      "cadata_test"
    ];

  disabledTestPaths = [
    # https://github.com/pycurl/pycurl/issues/856
    "tests/multi_test.py"
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
