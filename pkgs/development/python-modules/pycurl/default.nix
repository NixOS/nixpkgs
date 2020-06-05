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
  version = "7.43.0.5";
  disabled = isPyPy; # https://github.com/pycurl/pycurl/issues/208

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec7dd291545842295b7b56c12c90ffad2976cc7070c98d7b1517b7b6cd5994b3";
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

  # skip impure or flakey tests
  # See also:
  #   * https://github.com/NixOS/nixpkgs/issues/77304
  checkPhase = ''
    HOME=$TMPDIR pytest tests -k "not test_ssl_in_static_libs \
                     and not test_keyfunction \
                     and not test_keyfunction_bogus_return \
                     and not test_libcurl_ssl_gnutls \
                     and not test_libcurl_ssl_nss \
                     and not test_libcurl_ssl_openssl" \
                 --ignore=tests/getinfo_test.py \
                 --ignore=tests/memory_mgmt_test.py \
                 --ignore=tests/multi_memory_mgmt_test.py
  '';

  preConfigure = ''
    substituteInPlace setup.py --replace '--static-libs' '--libs'
    export PYCURL_SSL_LIBRARY=openssl
  '';

  meta = {
    homepage = "http://pycurl.sourceforge.net/";
    description = "Python wrapper for libcurl";
  };
}
