{
  lib,
  stdenv,
  buildPythonPackage,
  isPyPy,
  fetchFromGitHub,
  fetchpatch,
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
  version = "7.45.6";
  pyproject = true;

  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchFromGitHub {
    owner = "pycurl";
    repo = "pycurl";
    tag = "REL_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-M4rO0CaI2SmjdJVS7hWnJZrL72WvayB4aKn707KoNiQ=";
  };

  patches = [
    # curl 8.16 compatibility
    (fetchpatch {
      url = "https://github.com/pycurl/pycurl/commit/eb7f52eeef85feb6c117678d52803050bbdd7bc8.patch";
      hash = "sha256-hdwazS7R9duuMd/7S3SNAxVcToo3GhtyWu/1Q6qTMYc=";
    })
    # curl 8.17+ compatibility
    # https://github.com/pycurl/pycurl/pull/909
    (fetchpatch {
      name = "pycurl-8.17.0-compat.patch";
      url = "https://github.com/pycurl/pycurl/commit/ea92e3ca230a3ff3d464cb6816102fa157177aca.patch";
      hash = "sha256-kmlsG0SFfS9FdRNp8pPgudcWK6hSyD9x5oAedZLgBcY=";
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
