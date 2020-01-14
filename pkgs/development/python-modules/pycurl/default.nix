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
  version = "7.43.0.3";
  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "13nsvqhvnmnvfk75s8iynqsgszyv06cjp4drd3psi7zpbh63623g";
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
    pytest
    nose
    flaky
  ];

  checkPhase = ''
    HOME=$TMPDIR pytest tests -k "not test_ssl_in_static_libs \
                     and not test_keyfunction \
                     and not test_keyfunction_bogus_return \
                     and not test_libcurl_ssl_gnutls \
                     and not test_libcurl_ssl_nss \
                     and not test_libcurl_ssl_openssl" \
                 --ignore=tests/getinfo_test.py
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
