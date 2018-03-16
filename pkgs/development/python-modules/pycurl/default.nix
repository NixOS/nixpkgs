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
  version = "7.43.0.1";
  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ali1gjs9iliwjra7w0y5hwg79a2fd0f4ydvv6k27sgxpbr1n8s3";
  };

  buildInputs = [ curl openssl.out ];

  checkInputs = [ bottle pytest nose flaky ];

  checkPhase = ''
    py.test -k "not test_ssl_in_static_libs and not ssh_key_cb_test" tests
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
