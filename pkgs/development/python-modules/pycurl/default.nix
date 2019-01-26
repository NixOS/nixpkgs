{ buildPythonPackage
, isPyPy
, fetchPypi
, curl
, openssl
, bottle
, pytest
, nose
, flaky
}:

buildPythonPackage rec {
  pname = "pycurl";
  version = "7.43.0.2";
  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f0cdfc7a92d4f2a5c44226162434e34f7d6967d3af416a6f1448649c09a25a4";
  };

  buildInputs = [ curl openssl.out ];

  checkInputs = [ bottle pytest nose flaky ];

  checkPhase = ''
    py.test -k "not ssh_key_cb_test \
                and not test_libcurl_ssl_gnutls \
                and not test_libcurl_ssl_nss \
                and not test_libcurl_ssl_openssl \
                and not test_libcurl_ssl_unrecognized \
                and not test_request_with_verifypeer \
                and not test_ssl_in_static_libs" tests
  '';

  preConfigure = ''
    substituteInPlace setup.py --replace '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  meta = {
    homepage = http://pycurl.sourceforge.net/;
    description = "Python wrapper for libcurl";
  };
}
