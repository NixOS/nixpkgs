{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, gevent
, certifi
, six
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f59e5153f22e4a0be27b48aece8e45e19c1da294f8c49442b1c9e4d152c5c4c3";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ gevent certifi six backports_ssl_match_hostname ];

  # Several tests fail that require network
  doCheck = false;
  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/gwik/geventhttpclient";
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
